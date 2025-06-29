//
//  FilePattern.h
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef FilePattern_h
#define FilePattern_h

#include <stdio.h>
#include "Pattern.h"

enum fileCheckType
{
    kExist = 0,
    kContents = 1,
    kLink = 2,
};

class __attribute__((visibility("hidden"))) FilePattern : public Pattern
{
public:
    fileCheckType checkType_;
    std::string filePath_;
    std::string info1_;
    std::string info2_;
    
    FilePattern(Pattern patternBase, fileCheckType checkType,
                const char* path, const char* info1 = NULL, const char* info2 = NULL);
};

#endif /* FilePattern_h */
