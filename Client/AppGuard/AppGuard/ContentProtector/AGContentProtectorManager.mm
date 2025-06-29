//
//  AGContentProtectorManager.cpp
//  AppGuard
//
//  Created by NHN on 9/13/24.
//

#include "AGContentProtectorManager.hpp"

AG_PRIVATE_API AGContentProtectorManager::AGContentProtectorManager()
: screenshotDetector_(nullptr),
screenRecordDetector_(nullptr),
snapshotProtector_(nullptr),
protectContent_(nullptr)
{
}

AG_PRIVATE_API AGContentProtectorManager::~AGContentProtectorManager() {
}


AG_PRIVATE_API void AGContentProtectorManager::Initialize() {
    SetDetectScreenshot(true);
    SetDetectScreenRecord(true);
}

AG_PRIVATE_API void AGContentProtectorManager::SetProtectContent(bool enable) {
    if(!protectContent_)
    {
        protectContent_ = std::make_unique<AGProtectContent>();
    }
    protectContent_->SetActive(enable);
}

AG_PRIVATE_API void AGContentProtectorManager::SetDetectScreenshot(bool enable, int captureThreshold /*= 3*/, int captureInTimeThreshold /*= 30*/) {
    if(!screenshotDetector_) {
        screenshotDetector_ = std::make_unique<AGScreenshotDetector>();
    }
    screenshotDetector_->SetActive(enable, captureThreshold, captureInTimeThreshold);
}


AG_PRIVATE_API void AGContentProtectorManager::SetDetectScreenRecord(bool enable, int recordThresholdSec /*= 3*/) {
    if(!screenRecordDetector_) {
        screenRecordDetector_ = std::make_unique<AGScreenRecordDetector>();
    }
    screenRecordDetector_->SetActive(enable);
}


AG_PRIVATE_API void AGContentProtectorManager::SetProtectSnapshot(bool enable) {
    if(!snapshotProtector_) {
        snapshotProtector_ = std::make_unique<AGSnapshotProtector>();
    }
    snapshotProtector_->SetActive(enable);
}
