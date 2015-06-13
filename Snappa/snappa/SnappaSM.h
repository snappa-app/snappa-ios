//
//  SnappaSM.h
//  Snappa
//
//  Created by Sam Edson on 6/14/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#ifndef __Snappa__SnappaSM__
#define __Snappa__SnappaSM__

#include <stdio.h>




class SnappaSM {
public:
    SnappaSM(): events_(), outputs_() {};
    void start();
    SnappaOutputPointer step(SnappaEvent event);
    void reset();
    void undo();
    std::pair<SnappaState, SnappaOutputPointer> getNextValues(SnappaState state, SnappaEvent event);
private:
    SnappaState state_;
    std::vector<SnappaEvent> events_;
    std::vector<SnappaOutputPointer> outputs_;
    
    SnappaState getStartState();
};

#endif /* defined(__Snappa__SnappaSM__) */
