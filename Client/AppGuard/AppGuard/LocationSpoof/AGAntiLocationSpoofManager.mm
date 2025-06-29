//
//  AGAntiLocationSpoofManager.cpp
//  AppGuard
//
//  Created by NHN on 4/22/24.
//


#include "AGAntiLocationSpoofManager.hpp"
#include "AGLocationMon.h"
#include "Util.h"
#include "DetectManager.hpp"
#include "AGStatusMonitor.hpp"
#include "PatternManager.hpp"
#include <UIKit/UIKit.h>

__attribute__((visibility("hidden")))
AGAntiLocationSpoofManager::AGAntiLocationSpoofManager() {
    
}

__attribute__((visibility("hidden")))
AGAntiLocationSpoofManager::~AGAntiLocationSpoofManager() {
}

__attribute__((visibility("hidden")))
bool AGAntiLocationSpoofManager::Initialize() {
    dispatch_async(dispatch_get_main_queue(), ^{
        // LocationManager는 main loop에서 돌아야함.
        //Core Location calls the methods of your delegate object using the RunLoop of the thread on which you initialized the CLLocationManager object. That thread must itself have an active RunLoop, like the one found in your app’s main thread.
        //https://developer.apple.com/documentation/corelocation/cllocationmanager
        [AGLocationMon shared];
        responseQueue_ = dispatch_queue_create(NULL, NULL);
    });
 
    return true;
}

__attribute__((visibility("hidden")))
void AGAntiLocationSpoofManager::DidUpdateLocations(NSArray<CLLocation *> *locations) {
    for (CLLocation *location in locations) {
                
        bool isSimulate = IsSimulate(location);
        AGLog(@"Xcode Simulate Location: %@", isSimulate ? @"YES" : @"NO");

        if(isSimulate) {
            auto locationPatterns = STInstance(PatternManager)->getLocationSpoofPatterns();
            for(auto pattern : locationPatterns) {
                if(pattern->response_ != AGResponseTypeOff && pattern->name_ == AGPatternNameMockLocation)
                {
                        dispatch_async(responseQueue_, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                        Coordinate coordinate = [AGLocationMon returnCoordinateInvokeWithTarget:location selector:@selector(coordinate)];
                                         
                        double latitude = coordinate.latitude;
                        double longitude = coordinate.longitude;

                        double speed = [AGLocationMon returnDoubleInvokeWithTarget:location selector:@selector(speed)];
                        AGLog(@"speed: %f", speed);
                        double horizontalAccuracy = [AGLocationMon returnDoubleInvokeWithTarget:location selector:@selector(horizontalAccuracy)];
                        AGLog(@"horizontalAccuracy: %f", horizontalAccuracy);
                        double verticalAccuracy = [AGLocationMon returnDoubleInvokeWithTarget:location selector:@selector(verticalAccuracy)];
                        AGLog(@"verticalAccuracy: %f", verticalAccuracy);
                            
                        NSString* logDetail = [NSString stringWithFormat:@"%.2f, %.2f, %.2f, %.2f, %.2f", latitude, longitude, speed, horizontalAccuracy, verticalAccuracy];

                        DetectInfo* detectInfo = new DetectInfo(pattern->index_, pattern->group_, pattern->name_ , pattern->response_, [logDetail cStringUsingEncoding:NSUTF8StringEncoding]);
                        STInstance(DetectManager)->addDetectInfo(detectInfo);

                        if(pattern->response_ == AGResponseTypeBlock) {
                            STInstance(AGStatusMonitor)->setBlockDetectedStatus(pattern->index_, pattern->group_, pattern->name_, pattern->response_,[logDetail cStringUsingEncoding:NSUTF8StringEncoding]);
                        }
#pragma clang diagnostic pop
                    });
                }
            }
          
        }
    }
}

__attribute__((visibility("hidden")))
bool AGAntiLocationSpoofManager::IsSimulate(id location) {
    
    if (Util::isVersionEqualOrGreater([UIDevice currentDevice].systemVersion, @"15.0")) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        return [AGLocationMon returnBoolInvokeWithTarget:[location performSelector:@selector(sourceInformation)] selector:@selector(isSimulatedBySoftware)] == YES ? true : false;
#pragma clang diagnostic pop
    }
    return  false;
}

