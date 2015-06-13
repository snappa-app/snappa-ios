//
//  SnappaUtil.h
//  Snappa
//
//  Created by Sam Edson on 7/13/15.
//  Copyright (c) 2015 Sam Edson. All rights reserved.
//

#ifndef __Snappa__SnappaUtil__
#define __Snappa__SnappaUtil__

#include <stdio.h>

#include <string>
#include <vector>


class SnappaUtil {
public:
    static std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems);
    
    static std::vector<std::string> split(const std::string &s, char delim);
    
    static time_t stringToTime( const std::string& s );
};


#endif /* defined(__Snappa__SnappaUtil__) */
