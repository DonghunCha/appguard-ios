//
//  FileCollector.hpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 4. 19..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef FileCollector_hpp
#define FileCollector_hpp

#include <stdio.h>
#include <string>
#include <fstream>
#include <iostream>
#include "ICollector.hpp"

class __attribute__((visibility("hidden"))) FileCollector : public ICollector{

public:
    int Collect(std::string c);
};
#endif /* FileCollector_hpp */
