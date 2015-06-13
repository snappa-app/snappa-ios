//
//  SnappaUtil.cpp
//  Snappa
//
//  Created by Sam Edson on 7/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#include "SnappaUtil.h"

#include <sstream>


std::vector<std::string> &SnappaUtil::split(const std::string &s, char delim, std::vector<std::string> &elems) {
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}


std::vector<std::string> SnappaUtil::split(const std::string &s, char delim) {
    std::vector<std::string> elems;
    split(s, delim, elems);
    return elems;
}

time_t SnappaUtil::stringToTime( const std::string& s ) {
    std::istringstream stream( s );
    time_t t;
    stream >> t;
    return t;
}