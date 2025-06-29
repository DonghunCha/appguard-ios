//
//  FilePattern.cpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "FilePattern.h"

__attribute__((visibility("hidden"))) FilePattern::FilePattern(Pattern patternBase, fileCheckType checkType,
                         const char* path, const char* info1, const char* info2)
{
    index_ = patternBase.index_;
    group_ = patternBase.group_;
    name_ = patternBase.name_;
    response_ = patternBase.response_;
    checkType_ = checkType;
    filePath_ = path;
    
    if (info1 != NULL)
        info1_ = info1;
    if (info2 != NULL)
        info2_ = info2;
}
