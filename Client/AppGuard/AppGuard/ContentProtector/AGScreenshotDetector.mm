//
//  AGScreenshotDetector.m
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#include <chrono>
#include <ctime>
#include <queue>
#import "util.h"
#import "AGScreenshotDetector.h"
#import "DetectManager.hpp"
#import "PatternManager.hpp"
#import "AGStatusMonitor.hpp"



@interface AGScreenshotDetectorNotification()
@property ScreenShotDetectedCallback callback;
@property void* context;
@end

@implementation AGScreenshotDetectorNotification
- (void)takeScreenshotNotification:(NSNotification *)notification {
    if(self.callback) {
        self.callback(self.context);
    }
}

- (void)RegisterScreenshotNotification:(ScreenShotDetectedCallback)callback :(void*)context {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(takeScreenshotNotification:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];
    self.callback = callback;
    self.context = context;
    AGLog(@"The screen capture notification has been cleared.");
    
}

- (void)UnregisterScreenshotNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationUserDidTakeScreenshotNotification
                                                  object:nil];
     self.callback = nullptr;
     self.context = nullptr;
     AGLog(@"The screen capture notification registration has been canceled.");
}
@end



AG_PRIVATE_API AGScreenshotDetector::AGScreenshotDetector()
:captureInTimeThreshold_(10),
captureCountThreshold_(3),
active_(false),
notification_(nil)
{
}

AG_PRIVATE_API AGScreenshotDetector::~AGScreenshotDetector() {
    if(notification_) {
        [notification_ UnregisterScreenshotNotification];
    }
    notification_ = nil;
}

AG_PRIVATE_API void AGScreenshotDetector::DetectedCallback(void* context)
{
    AGScreenshotDetector* detector = reinterpret_cast<AGScreenshotDetector*>(context);
    auto now = std::chrono::system_clock::now();
    std::time_t utc_seconds = std::chrono::system_clock::to_time_t(now);
    detector->capturedTimeQueue_.push(utc_seconds);
    AGLog(@"A screen capture has been executed. (%zu)", detector->capturedTimeQueue_.size());
    if (detector->checkCaptureThreshold()) {
        auto screenCapturePatterns = STInstance(PatternManager)->getScreenCapturePatterns();
        for(auto pattern : screenCapturePatterns) {
            dispatch_async(dispatch_queue_create(NULL, NULL), ^{
                STInstance(DetectManager)->addDetectInfo(pattern->index_, pattern->group_, pattern->name_ , pattern->response_ , "");
                if(pattern->response_ == AGResponseTypeBlock) {
                    STInstance(AGStatusMonitor)->setBlockDetectedStatus(pattern->index_, pattern->group_, pattern->name_ , pattern->response_, "");
                }
            });
        }
    }
    
    
}

AG_PRIVATE_API void AGScreenshotDetector::SetActive(bool active, int captureCountThreshold /*= 3*/, int captureInTimeThreshold /*= 30*/) {
    if(!notification_) {
        notification_ = [[AGScreenshotDetectorNotification alloc] init];
    }
    
    active_ = active;
    
    if(active) {
        captureCountThreshold_ = captureCountThreshold;
        captureInTimeThreshold_ = captureInTimeThreshold;
        [notification_ RegisterScreenshotNotification: AGScreenshotDetector::DetectedCallback: this];
        AGLog(@"Screen capture detection has been activated.");
    } else {
        [notification_ UnregisterScreenshotNotification];
        clearCapturedTimeQueue();
        AGLog(@"Screen capture detection has been deactivated.");
    }
}

AG_PRIVATE_API bool AGScreenshotDetector::checkCaptureThreshold() {
    bool detected = false;
    
    if(capturedTimeQueue_.size() >= captureCountThreshold_ ) {
        if(capturedTimeQueue_.back() - capturedTimeQueue_.front() <= captureInTimeThreshold_) {
            detected = true;
            clearCapturedTimeQueue();
        } else {
            capturedTimeQueue_.pop();
        }
    }
  
    return detected;
}

AG_PRIVATE_API void AGScreenshotDetector::clearCapturedTimeQueue() {
    while(!capturedTimeQueue_.empty())
    {
        capturedTimeQueue_.pop();
    }
}
