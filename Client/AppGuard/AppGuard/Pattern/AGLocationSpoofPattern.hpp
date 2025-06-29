//
//  AGLocationPattern.hpp
//  AppGuard
//
//  Created by NHN on 4/23/24.
//

#ifndef AGLocationSpoofPattern_hpp
#define AGLocationSpoofPattern_hpp

#include "Pattern.h"
#include <string>

typedef NS_ENUM(int, AGLocationSpoofPatternCheckType) {
    AGLocationSpoofPatternCheckTypeAntiSpoof = 0,
};

class __attribute__((visibility("hidden"))) AGLocationSpoofPattern : public Pattern {
public:
    AGLocationSpoofPattern(Pattern patternBase, AGLocationSpoofPatternCheckType checkType);
};
#endif /* AGLocationSpoofPattern_hpp */
