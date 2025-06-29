//
//  AGScreenshotDetector.h
//  AppGuard
//
//  Created by NHN on 9/23/24.
//

#import <Foundation/Foundation.h>
#include <queue>
#import "AGCommon.hpp"

// internal Objc class obfuscation
#ifndef DEBUG
#define AGScreenshotDetectorNotification e58gBMf8oCRYGMBm6py9
#define RegisterScreenshotNotification dlZmj1d0XwvK2RippNkg
#define UnregisterScreenshotNotification EZXJI9WY9FHGGXP5IGWEV
#endif


typedef void (*ScreenShotDetectedCallback)(void* context);

@interface AGScreenshotDetectorNotification : NSObject
- (void)RegisterScreenshotNotification:(ScreenShotDetectedCallback)callback :(void*)context;
- (void)UnregisterScreenshotNotification;
@end

class AG_PRIVATE_API AGScreenshotDetector {
public:
    AGScreenshotDetector();
    ~AGScreenshotDetector();
    void SetActive(bool active, int captureThreshold = 3, int captureInTimeThreshold = 30);
    static void DetectedCallback(void* context);
    
private:
    bool checkCaptureThreshold();
    bool active_;
    int captureCountThreshold_;
    int captureInTimeThreshold_;
    std::queue<std::time_t> capturedTimeQueue_;
    AGScreenshotDetectorNotification* notification_;
    void clearCapturedTimeQueue();
    
};


