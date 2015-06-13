//
//  SnappaEvent.cpp
//  Snappa
//
//  Created by Sam Edson on 6/14/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#include "SnappaEvent.h"


using namespace std;


SnappaEvent::SnappaEvent(std::string outcome) {
    outcome_ = outcome;
}

string SnappaEvent::getOutcome() {
    return outcome_;
}

string SnappaEvent::stringFromPlayerPosition(PlayerPosition position) {
    if (position == THEM_LEFT) {
        return PlayerPositionStringThemLeft;
    } else if (position == THEM_RIGHT) {
        return PlayerPositionStringThemRight;
    } else if (position == US_LEFT) {
        return PlayerPositionStringUsLeft;
    } else if (position == US_RIGHT) {
        return PlayerPositionStringUsRight;
    }
    return "NOT A PLAYER POSITION";
}