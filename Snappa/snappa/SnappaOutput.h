//
//  SnappaOutput.h
//  Snappa
//
//  Created by Sam Edson on 6/14/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#ifndef __Snappa__SnappaOutput__
#define __Snappa__SnappaOutput__

#include <stdio.h>

#include <string>


class SnappaOutput {
public:
    SnappaOutput() : message_("") {};
    std::string message();
    void message(std::string newMessage);
private:
    std::string message_;
};


#endif /* defined(__Snappa__SnappaOutput__) */
