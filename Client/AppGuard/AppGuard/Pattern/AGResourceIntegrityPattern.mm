//
//  ResourceIntegrityPattern.cpp
//  AppGuard
//
//  Created by NHN on 2023/05/02.
//

#include "AGResourceIntegrityPattern.hpp"

__attribute__((visibility("hidden"))) AGResourceIntegrityPattern::AGResourceIntegrityPattern(Pattern patternBase, AGResourceIntegrityPatternCheckType checkType, std::string resourceSubPath) {
    index_ = patternBase.index_;
    group_ = patternBase.group_;
    name_ = patternBase.name_;
    response_ = patternBase.response_;
    this->resourceSubPath = resourceSubPath;
    this->checkType = checkType;
}

__attribute__((visibility("hidden"))) AGResourceIntegrityPatternCheckType AGResourceIntegrityPattern::getCheckType() {
    return this->checkType;
}

__attribute__((visibility("hidden"))) std::string AGResourceIntegrityPattern::getResourceSubPath() {
    return this->resourceSubPath;
}
