//
//  AGContentProtectorManager.hpp
//  AppGuard
//
//  Created by NHN on 9/13/24.
//

#ifndef AGContentProtectorManager_hpp
#define AGContentProtectorManager_hpp

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <memory>
#import "AGCommon.hpp"
#import "AGSnapshotProtector.h"
#import "AGProtectContent.h"
#import "AGScreenRecordDetector.h"
#import "AGScreenshotDetector.h"

class AG_PRIVATE_API AGContentProtectorManager {
public:
    AGContentProtectorManager();
    ~AGContentProtectorManager();
    void Initialize();
    void SetProtectContent(bool enable);
    void SetDetectScreenshot(bool enable, int captureThreshold = 3, int captureInTimeThreshold = 30);
    void SetDetectScreenRecord(bool enable, int recordThresholdSec = 3);
    void SetProtectSnapshot(bool enable);
private:
    std::unique_ptr<AGSnapshotProtector> snapshotProtector_;
    std::unique_ptr<AGScreenRecordDetector> screenRecordDetector_;
    std::unique_ptr<AGScreenshotDetector> screenshotDetector_;
    std::unique_ptr<AGProtectContent> protectContent_;

};
#endif /* AGContentProtectorManager_hpp */
