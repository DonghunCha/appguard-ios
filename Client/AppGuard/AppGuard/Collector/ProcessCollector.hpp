//
//  ProcessCollector.hpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 4. 22..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef ProcessCollector_hpp
#define ProcessCollector_hpp

#include <stdio.h>
#include "ICollector.hpp"

class __attribute__((visibility("hidden"))) ProcessCollector : public ICollector{
    
public:
    int Collect(std::string c);
};

#endif /* ProcessCollector_hpp */
