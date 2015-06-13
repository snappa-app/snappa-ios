//
//  SnappaOutput.cpp
//  Snappa
//
//  Created by Sam Edson on 6/14/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#include "SnappaOutput.h"

#include <iostream>


using namespace std;


string SnappaOutput::message() {
    return message_;
}

void SnappaOutput::message(string newMessage) {
    message_ = newMessage;
}