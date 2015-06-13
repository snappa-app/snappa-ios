//
//  SnappaState.h
//  Snappa
//
//  Created by Sam Edson on 6/14/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#ifndef __Snappa__SnappaState__
#define __Snappa__SnappaState__

#include <stdio.h>

#include <ctime>
#include <string>

#include "Constants.h"
#include "SnappaEvent.h"
#include "SnappaOutput.h"


class SnappaState {
public:
    SnappaState(std::string eventString, time_t timestamp);
    SnappaState copy(SnappaEvent event);
    static SnappaState startState();

    GameExpectation expects();
    void expects(GameExpectation newExpectation);
    
    void incrementPlayer();
    PlayerPosition nextPlayer();
    void setCurrentPlayer(PlayerPosition newPlayer);
    PlayerPosition getCurrentPlayer();
    
    void togglePlayerOrder();
    
    SnappaEvent getEvent();
    
    void setTimestamp(time_t newTimestamp);
    
    void setOutput(SnappaOutput output);
    SnappaOutput getOutput();
    
    std::string timestampString();
    std::string pointString();
    
    // State changes
    void addPoint(bool isUs);
    void addThirdDrink(bool isUs);
    void finishBeer(bool isUs);
    
//    static SnappaState decode(std::string logLine);
    
protected:
    GameExpectation expects_;
    
    PlayerPosition currentPlayer_;
    
    SnappaEvent event_;
    std::time_t timestamp_;
    
    SnappaOutput output_;
    
    int usDrinkThirds_;
    int themDrinkThirds_;
    
    int usPoints_;
    int themPoints_;
    
    bool playerOrderToggle_;
};


#endif /* defined(__Snappa__SnappaState__) */
