//
//  AGResourceIntegrityPattern.hpp
//  AppGuard
//
//  Created by NHN on 2023/05/02.
//

#ifndef AGResourceIntegrityPattern_hpp
#define AGResourceIntegrityPattern_hpp

#include <stdio.h>
#include <Pattern.h>

typedef NS_ENUM(int, AGResourceIntegrityPatternCheckType) {
    AGResourceIntegrityPatternCheckTypeNone = -1,
    AGResourceIntegrityPatternCheckTypePlistInfo = 0,
};

class __attribute__((visibility("hidden"))) AGResourceIntegrityPattern: public Pattern
{
public:
    AGResourceIntegrityPattern(Pattern patternBase, AGResourceIntegrityPatternCheckType checkType, std::string resourceSubPath);
    AGResourceIntegrityPatternCheckType getCheckType();
    std::string getResourceSubPath();
private:
    AGResourceIntegrityPatternCheckType checkType;
    std::string resourceSubPath;
    
};

#endif /* AGResourceIntegrityPattern_hpp */
