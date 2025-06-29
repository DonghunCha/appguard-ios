//
//  FileCollector.cpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 4. 19..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "FileCollector.hpp"

__attribute__((visibility("hidden"))) int FileCollector::Collect(std::string filename) {
    std::ifstream fileopen;
    fileopen.open(filename.c_str(),std::ios::in|std::ios::binary);
    
    // file exist => jailbreak
    if(fileopen.fail()){
        return 0;
    } else {
        return 1;
    }
}