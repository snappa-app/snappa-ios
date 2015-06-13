//
//  SnappaGame.h
//  Snappa
//
//  Created by Sam Edson on 6/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#ifndef __Snappa__SnappaGame__
#define __Snappa__SnappaGame__

#include <stdio.h>

#include <array>
#include <ctime>
#include <tuple>
#include <vector>

#include "SnappaEvent.h"
#include "SnappaOutput.h"
#include "SnappaState.h"


class SnappaGame {
public:
    SnappaGame(std::array<std::string, 4> players): players_(players) {};
    
    // State Machine
    void start();
    SnappaOutput step(SnappaEvent event, time_t timestamp = 0);
    SnappaOutput undo();
    
    void togglePlayerOrder();
    PlayerPosition nextPlayer();

    // Getters
    std::string getLog();
    std::array<std::string, 4> getPlayers();
    std::string nameFromPosition(PlayerPosition position);
    PlayerPosition getCurrentPlayer();
    SnappaOutput setCurrentPlayer(PlayerPosition newPlayer);
    
    std::string encode();
    static SnappaOutput decode(SnappaGame& snappaGame, std::string gameLog);
private:
    // State
    std::vector<SnappaState> states_;

    // Players and Scores
    std::array<std::string, 4> players_;
    PlayerPosition startingPlayer_;
    
    // The handler chooser
    SnappaState getNextValues(SnappaState state, SnappaEvent event);
    
    // Possible handlers
    SnappaState handleHighLow(SnappaState state, SnappaEvent event);
    SnappaState handleThrow(SnappaState state, SnappaEvent event);
    SnappaState handleRollSink(SnappaState state, SnappaEvent event);
    SnappaState handlePlayerSwitch(SnappaState state, SnappaEvent event);    
};


#endif /* defined(__Snappa__SnappaGame__) */
