//
//  SnappaGame.cpp
//  Snappa
//
//  Created by Sam Edson on 6/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#include "SnappaGame.h"

#include <iostream>

#include "SnappaUtil.h"


using namespace std;


void SnappaGame::start() {
    states_.push_back(SnappaState::startState());
}

SnappaOutput SnappaGame::step(SnappaEvent event, time_t timestamp) {
    // Make a copy of the last state
    SnappaState stateCopy = states_.back().copy(event);
    
    // Step and add the next state to the vector of states
    SnappaState nextState = this->getNextValues(stateCopy, event);
    
    if (timestamp != 0) {
        nextState.setTimestamp(timestamp);
    }
    
    states_.push_back(nextState);
    
    return nextState.getOutput();
}


SnappaOutput SnappaGame::setCurrentPlayer(PlayerPosition newPlayer) {
    // Make sure that we didn't just set the same player (makes undo clunky)
    if (newPlayer != states_.back().getCurrentPlayer()) {
        states_.back().expects(PLAYER_SWITCH);
        string newPlayerString = SnappaEvent::stringFromPlayerPosition(newPlayer);
        return step(SnappaEvent(newPlayerString));
    } else {
        SnappaOutput output = SnappaOutput();
        output.message("Already set player");
        return output;
    }
}


SnappaOutput SnappaGame::undo() {
    // Prevents undoing past the first two events (start game and choosing
    // starting player)
    if (states_.size() == 2) {
        SnappaOutput output = SnappaOutput();
        output.message("");
        return output;
    }
    
    // Double undo for when there is a sunken cup because it requires two
    // steps and you can't press the undo button when the choices are up.
    string lastEventString = states_.back().getEvent().getOutcome();
    if (lastEventString == RollFiveOutcomeDidNotRollFive ||
        lastEventString == RollFiveOutcomeDrinkAnotherBeer) {
        states_.pop_back();
    }
    
    // Undo the last state
    states_.pop_back();
    
    return states_.back().getOutput();
}

void SnappaGame::togglePlayerOrder() {
    states_.back().togglePlayerOrder();
}

PlayerPosition SnappaGame::nextPlayer() {
    return states_.back().nextPlayer();
}

string SnappaGame::getLog() {
    string log = "";
    for (auto state = states_.begin(); state < states_.end(); state++) {
        log += state->getOutput().message() + "\n";
    }
    return log;
}


array<string, 4> SnappaGame::getPlayers() {
    return players_;
}


string SnappaGame::nameFromPosition(PlayerPosition position) {
    return players_[position];
}


PlayerPosition SnappaGame::getCurrentPlayer() {
    return states_.back().getCurrentPlayer();
}


SnappaState SnappaGame::getNextValues(SnappaState state, SnappaEvent event) {
    switch (state.expects()) {
        case HIGHLOW:
            return this->handleHighLow(state, event);
            break;
        case GAMEPLAY:
            return this->handleThrow(state, event);
            break;
        case ROLL_SINK:
            return this->handleRollSink(state, event);
            break;
        case PLAYER_SWITCH:
            return this->handlePlayerSwitch(state, event);
            break;
        default:
            throw "Error unknown expectation";
            return SnappaState("ERROR", 0);
            break;
    }
}


SnappaState SnappaGame::handleHighLow(SnappaState state, SnappaEvent event) {
    
    string outcome = event.getOutcome();
    
    if (outcome == PlayerPositionStringUsLeft) {
        state.setCurrentPlayer(US_LEFT);
    } else if (outcome == PlayerPositionStringUsRight) {
        state.setCurrentPlayer(US_RIGHT);
    } else if (outcome == PlayerPositionStringThemLeft) {
        state.setCurrentPlayer(THEM_LEFT);
    } else if (outcome == PlayerPositionStringThemRight) {
        state.setCurrentPlayer(THEM_RIGHT);
    }
    
    startingPlayer_ = state.getCurrentPlayer();
    
    SnappaOutput output = SnappaOutput();
    output.message(outcome + "|STARTING_PLAYER|" + this->nameFromPosition(state.getCurrentPlayer()) + state.pointString());
    
    state.expects(GAMEPLAY);
    
    state.setOutput(output);
    return state;
}


SnappaState SnappaGame::handleThrow(SnappaState state, SnappaEvent event) {

    // Get what happened in the game
    string outcome = event.getOutcome();

    bool isUs = (state.getCurrentPlayer() <= 1) ? true : false;

    if (outcome == ThrowStringBack ||
        outcome == ThrowStringCup) {
        state.addPoint(isUs);
        state.addThirdDrink( ! isUs);

    // Add a finish beer to opposite of thrower
    } else if (outcome == ThrowStringCupFive) {
        // Used to be state.addThirdDrink( ! isUs);
        // but that is incorrect apparently
        state.finishBeer( ! isUs);

    // Add a finish beer to opposite of thrower
    } else if (outcome == ThrowStringCupSink) {
        state.addPoint(isUs);
        state.finishBeer( ! isUs);

        // We are now looking for a roll_sink confirmation
        state.expects(ROLL_SINK);

    // Add a third of a drink to the thrower
    } else if (outcome == ThrowStringMissTable) {
        state.addThirdDrink(isUs);

    // Currently being used as nothing
    } else if (outcome == ThrowStringSloppyPlay) { }

    // Print the output
    SnappaOutput output = SnappaOutput();
    output.message(outcome + "|THROW|" + this->nameFromPosition(state.getCurrentPlayer()) + "|" + outcome + state.pointString());

    // Move on to the next player
    state.incrementPlayer();

    state.setOutput(output);
    return state;
}


SnappaState SnappaGame::handleRollSink(SnappaState state, SnappaEvent event) {
    
    string outcome = event.getOutcome();
    SnappaOutput output = SnappaOutput();

    // Self here because player has already incremented
    if (outcome == RollFiveOutcomeDrinkAnotherBeer) {
        bool isUs = (state.getCurrentPlayer() <= 1) ? true : false;
        state.finishBeer(isUs);
    }

    output.message(outcome + "|SUNK_CUP_ROLL|" + this->nameFromPosition(state.getCurrentPlayer()) + "|" + event.getOutcome() + state.pointString());

    
    // We do not increment the player because it already happened at the throw
    state.expects(GAMEPLAY);
    
    state.setOutput(output);
    return state;
}


SnappaState SnappaGame::handlePlayerSwitch(SnappaState state, SnappaEvent event) {
    
    SnappaOutput output = SnappaOutput();
    string outcome = event.getOutcome();

    if (outcome == PlayerPositionStringUsLeft) {
        state.setCurrentPlayer(US_LEFT);
    } else if (outcome == PlayerPositionStringUsRight) {
        state.setCurrentPlayer(US_RIGHT);
    } else if (outcome == PlayerPositionStringThemLeft) {
        state.setCurrentPlayer(THEM_LEFT);
    } else if (outcome == PlayerPositionStringThemRight) {
        state.setCurrentPlayer(THEM_RIGHT);
    }
    
    output.message(outcome + "|PLAYER_SWITCH|" + this->nameFromPosition(state.getCurrentPlayer()) + "|" + event.getOutcome() + state.pointString());
    
    // Back to gameplay
    state.expects(GAMEPLAY);
    
    state.setOutput(output);
    return state;
}


///////////////////////////////////////////////////////////////////////
// Encode and Decode

std::string SnappaGame::encode() {
    return getLog();
}


SnappaOutput SnappaGame::decode(SnappaGame& snappaGame, string gameLog) {
    snappaGame.start();
    SnappaOutput finalOutput;
    vector<string> logLines = SnappaUtil::split(gameLog, '\n');
    for (auto linePtr = logLines.begin(); linePtr < logLines.end(); linePtr++) {
        string logLine = *linePtr;
        cout << "logLine: " << logLine << endl;
        vector<string> logSplit = SnappaUtil::split(logLine, '|');
        for (auto logSplitPtr = logSplit.begin(); logSplitPtr < logSplit.end(); logSplitPtr++) {
            cout << "+ " << *logSplitPtr << endl;
        }
        auto emptyPos = std::find(logSplit.begin(), logSplit.end(), "");
        if (emptyPos != logSplit.end()) {
            cout << "CCCC" << endl;
            long between = distance(logSplit.begin(), emptyPos);
            time_t timestamp = SnappaUtil::stringToTime(logSplit[between - 1]);
            cout << "timestamp: " << timestamp << endl;
            string outcome = logSplit[0];
            cout << "outcome: " << outcome << endl;
            finalOutput = snappaGame.step(outcome, timestamp);
        } else if (logLine == "START_GAME") {
        } else {
            throw std::runtime_error("No '||' exists in logLine string of SnappaState::decode");
        }
    }
    return finalOutput;
}


