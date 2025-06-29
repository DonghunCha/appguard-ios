//
//  AGMacroToolDetector.m
//  AppGuard
//
//  Created by NHN on 11/19/24.
//

#include "AGMacroToolDetector.h"
#include "PatternManager.hpp"
#include "CommonAPI.hpp"
#include "AGStatusMonitor.hpp"
#import <UIKit/UIKit.h>


AG_PRIVATE_API AGMacroToolDetector::AGMacroToolDetector()
:runningSwitchControlDetector_(false) {
    
}

AG_PRIVATE_API AGMacroToolDetector::~AGMacroToolDetector() {
    runningSwitchControlDetector_ = false;
}

AG_PRIVATE_API void AGMacroToolDetector::Initailize() {
    StartSwitchControlDetector();
}

AG_PRIVATE_API void AGMacroToolDetector::StartSwitchControlDetector() {
    dispatch_async(dispatch_queue_create(NULL, NULL), ^{
        runningSwitchControlDetector_ = true;
        AGLog(@"Start SwitchControl Detector");
        while(runningSwitchControlDetector_) {
            @autoreleasepool {
                if(UIAccessibilityIsSwitchControlRunning()) {
                    auto macroToolPatterns = STInstance(PatternManager)->getMacroToolPatterns();
                    for(auto pattern : macroToolPatterns) {
                        if(pattern->name_ == AGPatternNameSwitchControl) {
                            
                            dispatch_async(dispatch_queue_create(NULL, NULL), ^{
                                STInstance(DetectManager)->addDetectInfo(pattern->index_, pattern->group_, pattern->name_ , pattern->response_ , "");
                                if(pattern->response_ == AGResponseTypeBlock) {
                                    STInstance(AGStatusMonitor)->setBlockDetectedStatus(pattern->index_, pattern->group_, pattern->name_ , pattern->response_, "");
                                }
                            });
                            break;
                        }
                    }
                }
            }
            STInstance(CommonAPI)->stdSleepFor(1);
        }});
}
