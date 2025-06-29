//
//  AGStatusMonitor.hpp
//  AppGuard
//
//  Created by NHN on 2023/10/25.
//

#ifndef AGStatusMonitor_hpp
#define AGStatusMonitor_hpp

#include <stdio.h>
#include <mach/mach.h>
#include "../Core/ResponseManager.hpp"

class __attribute__((visibility("hidden"))) AGStatusMonitor {
public:
    AGStatusMonitor();
    ~AGStatusMonitor();
    void start();
    void setBlockDetectedStatus(const int index, const AGPatternGroup group, const AGPatternName name, AGResponseType type, const char* detail);
 
private:
    void startExitStatusMonitor();
    void startAppGuardIntegrityMonitor();
    bool isBlockDetected_;
    int exitWaitTimeoutCountDown_;
    DetectInfo* firstDetectInfo_;
    static const int kExitWaitTimeoutSec_ = ResponseManager::kResponseSecond_ * 2;
};
#endif /* AGStatusMonitor_hpp */
