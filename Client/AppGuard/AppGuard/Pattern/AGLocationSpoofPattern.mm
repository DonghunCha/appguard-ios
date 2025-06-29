//
//  AGLocationPattern.cpp
//  AppGuard
//
//  Created by NHN on 4/23/24.
//

#include "AGLocationSpoofPattern.hpp"

__attribute__((visibility("hidden")))
AGLocationSpoofPattern::AGLocationSpoofPattern(Pattern patternBase, AGLocationSpoofPatternCheckType checkType) {
    index_ = patternBase.index_;
    group_ = patternBase.group_;
    name_ = patternBase.name_;
}
