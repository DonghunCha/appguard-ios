//
//  ProcPattern.cpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "ProcPattern.h"

__attribute__((visibility("hidden"))) ProcPattern::ProcPattern(Pattern patternBase, int checkType, const char* processName)
{
    index_ = patternBase.index_;
    group_ = patternBase.group_;
    name_ = patternBase.name_;
    response_ = patternBase.response_;
    checkType_ = checkType;
    processName_ = processName;
}
