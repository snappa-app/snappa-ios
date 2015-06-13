//
//  SnappaEvent.h
//  Snappa
//
//  Created by Sam Edson on 6/14/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#ifndef __Snappa__SnappaEvent__
#define __Snappa__SnappaEvent__

#include <stdio.h>

#include <string>

#include "Constants.h"


static const std::string PlayerPositionStringUsLeft = "SetUsLeft";
static const std::string PlayerPositionStringUsRight = "SetUsRight";
static const std::string PlayerPositionStringThemLeft = "SetThemLeft";
static const std::string PlayerPositionStringThemRight = "SetThemRight";

static const std::string ThrowStringLeftCatch = "LeftCatch";
static const std::string ThrowStringRightCatch = "RightCatch";
static const std::string ThrowStringBack = "Back";
static const std::string ThrowStringCup = "Cup";
static const std::string ThrowStringCupFive = "CupFive";
static const std::string ThrowStringCupSink = "CupSink";
static const std::string ThrowStringMissTable = "MissTable";
static const std::string ThrowStringSloppyPlay = "SloppyPlay";

static const std::string RollFiveOutcomeDrinkAnotherBeer = "DrinkAnotherBeer";
static const std::string RollFiveOutcomeDidNotRollFive = "DidNotRollFive";

static const std::string UndoThrowString = "UndoThrow";


class SnappaEvent {
public:
    SnappaEvent(std::string outcome);
    std::string getOutcome();
    static std::string stringFromPlayerPosition(PlayerPosition position);
private:
    std::string outcome_;
};


typedef std::shared_ptr<SnappaEvent> SnappaEventPointer;


#endif /* defined(__Snappa__SnappaEvent__) */
