//
//  AGMacroToolDetector.h
//  AppGuard
//
//  Created by NHN on 11/19/24.
//

#include "util.h"
#include "AGCommon.hpp"

#import <Foundation/Foundation.h>
#include <dispatch/dispatch.h>

class AG_PRIVATE_API AGMacroToolDetector {
public:
    AGMacroToolDetector();
    ~AGMacroToolDetector();
    void Initailize();
private:
    void StartSwitchControlDetector();
    bool runningSwitchControlDetector_;
};
