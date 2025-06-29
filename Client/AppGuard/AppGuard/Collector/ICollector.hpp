//
//  ICollector.hpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 4. 19..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef ICollector_hpp
#define ICollector_hpp

#include <stdio.h>
#include <string>

class __attribute__((visibility("hidden"))) ICollector
{
public:
    virtual int Collect(std::string c) = 0;
};
#endif /* ICollector_hpp */
