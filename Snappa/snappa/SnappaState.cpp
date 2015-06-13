//
//  SnappaState.cpp
//  Snappa
//
//  Created by Sam Edson on 6/14/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#include "SnappaState.h"

#include "SnappaUtil.h"


using namespace std;


SnappaState::SnappaState(string eventString, time_t timestamp):
                         event_(eventString),
                         timestamp_(timestamp)
{
    expects_ = HIGHLOW;
    
    currentPlayer_ = US_LEFT;
    
    usDrinkThirds_ = 0;
    themDrinkThirds_ = 0;
    usPoints_ = 0;
    themPoints_ = 0;
    
    playerOrderToggle_ = false;
}

SnappaState SnappaState::copy(SnappaEvent event) {
    SnappaState copyState = SnappaState(event.getOutcome(), time(nullptr));
    
    copyState.expects_ = this->expects_;
    
    copyState.currentPlayer_ = this->currentPlayer_;
    
    copyState.usDrinkThirds_ = this->usDrinkThirds_;
    copyState.themDrinkThirds_ = this->themDrinkThirds_;
    copyState.usPoints_ = this->usPoints_;
    copyState.themPoints_ = this->themPoints_;
    
    copyState.playerOrderToggle_ = this->playerOrderToggle_;

    return copyState;
}

SnappaState SnappaState::startState() {
    SnappaState startState = SnappaState("Start Game", time(nullptr));
    
    SnappaOutput output = SnappaOutput();
    output.message("START_GAME");
    startState.output_ = output;
    
    return startState;
}

GameExpectation SnappaState::expects() {
    return expects_;
}

void SnappaState::expects(GameExpectation newExpectation) {
    if (newExpectation == HIGHLOW) {
        throw "Error: GameExpectation HIGHLOW is only the starting expectation";
    }
    expects_ = newExpectation;
}


void SnappaState::setCurrentPlayer(PlayerPosition newPlayer) {
    currentPlayer_ = newPlayer;
}

void SnappaState::incrementPlayer() {
    currentPlayer_ = this->nextPlayer();
}

PlayerPosition SnappaState::nextPlayer() {
    if ( ! playerOrderToggle_ ) {
        switch (currentPlayer_) {
            case US_LEFT:
                return THEM_LEFT;
                break;
            case US_RIGHT:
                return THEM_RIGHT;
                break;
            case THEM_LEFT:
                return US_RIGHT;
                break;
            case THEM_RIGHT:
                return US_LEFT;
                break;
            default:
                break;
        }
    } else {
        switch (currentPlayer_) {
            case US_LEFT:
                return THEM_RIGHT;
                break;
            case US_RIGHT:
                return THEM_LEFT;
                break;
            case THEM_LEFT:
                return US_LEFT;
                break;
            case THEM_RIGHT:
                return US_RIGHT;
                break;
            default:
                break;
        }
    }

    // Should never get here
    return US_LEFT;
}

PlayerPosition SnappaState::getCurrentPlayer() {
    return currentPlayer_;
}

void SnappaState::togglePlayerOrder() {
    playerOrderToggle_ = !(playerOrderToggle_);
}

SnappaEvent SnappaState::getEvent() {
    return event_;
}

void SnappaState::setTimestamp(time_t newTimestamp) {
    timestamp_ = newTimestamp;
}

void SnappaState::setOutput(SnappaOutput output) {
    output_ = output;
}

SnappaOutput SnappaState::getOutput() {
    return output_;
}


string SnappaState::timestampString() {
    return "|" + to_string(timestamp_);
}

string SnappaState::pointString() {
    return timestampString() +
    "||US_PTS|" +  std::to_string(usPoints_) +
    "|US_THIRDS|" +  std::to_string(usDrinkThirds_) +
    "|THEM_PTS|" +  std::to_string(themPoints_) +
    "|THEM_THIRDS|" +  std::to_string(themDrinkThirds_);
}

// State changes
void SnappaState::addPoint(bool isUs) {
    if (isUs) {
        usPoints_ += 1;
    } else {
        themPoints_ += 1;
    }
}


void SnappaState::addThirdDrink(bool isUs) {
    if (isUs) {
        usDrinkThirds_ += 1;
    } else {
        themDrinkThirds_ += 1;
    }
}

void SnappaState::finishBeer(bool isUs) {
    addThirdDrink(isUs);
    
    int *usOrThemThirds = isUs ? &usDrinkThirds_ : &themDrinkThirds_;
    while ( *usOrThemThirds % 3 != 0) {
        addThirdDrink(isUs);
    }
}

///////////////////////////////////////////////////////////////////////
// Decode

//
//SnappaState SnappaState::decode(std::string logLine) {
//    vector<string> logSplit = SnappaUtil::split(logLine, '|');
//    auto emptyPos = std::find(logSplit.begin(), logSplit.end(), "");
//    if (emptyPos != logSplit.end()) {
//        long between = distance(logSplit.begin(), emptyPos);
//        time_t timestamp = SnappaUtil::stringToTime(logSplit[between - 1]);
//        string outcome = logSplit[0];
//        SnappaState snappaState = SnappaState(outcome, timestamp);
//        
//        
//        
//        return snappaState;
//
//    } else {
//        throw "No '||' exists in logLine string of SnappaState::decode";
//        return SnappaState("ERROR Decoding", 0);
//    }
//}


