//
//  AGScreenRecordDetector.m
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#import "AGScreenRecordDetector.h"
#import "UIKit/UIKit.h"
#import "util.h"
#import "DetectManager.hpp"
#import "PatternManager.hpp"
#import "AGStatusMonitor.hpp"

AG_PRIVATE_API AGScreenRecordDetector::AGScreenRecordDetector()
: active_(false),
recordedTimeSec_(0),
recordedTimeThresholdSec_(5),
monitorQueue_(nil)
{
}

AG_PRIVATE_API AGScreenRecordDetector::~AGScreenRecordDetector() {
    
}

AG_PRIVATE_API void AGScreenRecordDetector::SetActive(bool active, int recordedTimeThresholdSec) {
    
    active_ = active;

    if(active_) {
        recordedTimeThresholdSec_ = recordedTimeThresholdSec;
        monitorQueue_ = [[NSOperationQueue alloc] init];
        [monitorQueue_ addOperationWithBlock:^{
            while (active_) {
                @autoreleasepool {
                    BOOL isCaptured = [[UIScreen mainScreen] isCaptured];
                    if (isCaptured){
                        recordedTimeSec_++;
                        AGLog(@"isCaptured: %@ (%d)", isCaptured ? @"YES" : @"NO", recordedTimeSec_);
                        if (recordedTimeSec_ >= recordedTimeThresholdSec_) {
                            recordedTimeSec_ = 0;
                            auto screenRecordPatterns = STInstance(PatternManager)->getScreenRecordPatterns();
                            for(auto pattern : screenRecordPatterns) {
                                dispatch_async(dispatch_queue_create(NULL, NULL), ^{
                                    STInstance(DetectManager)->addDetectInfo(pattern->index_, pattern->group_, pattern->name_ , pattern->response_ , "");
                                    if(pattern->response_ == AGResponseTypeBlock) {
                                        STInstance(AGStatusMonitor)->setBlockDetectedStatus(pattern->index_, pattern->group_, pattern->name_ , pattern->response_, "");
                                    }
                                });
                            }
                        }
                    }
                    sleep(1);
                }
            }
        }];
        AGLog(@"Screen recording detection has been activated.");
    } else {
        AGLog(@"Screen recording detection has been deactivated.");
        monitorQueue_ = nil;
    }
}

