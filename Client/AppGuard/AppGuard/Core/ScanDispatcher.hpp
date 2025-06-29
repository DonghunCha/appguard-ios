//
//  ScanDispatcher.hpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 5. 2..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef ScanDispatcher_hpp
#define ScanDispatcher_hpp

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <mutex>
#include <condition_variable>
#include <dispatch/dispatch.h>
#include "Log.h"
#include "Util.h"
#include "Pattern.h"
#include "ASString.h"
#include "LogNCrash.h"
#include "FilePattern.h"
#include "ProcPattern.h"
#include "HookManager.hpp"
#include "DebugManager.hpp"
#include "DetectManager.hpp"
#include "FileCollector.hpp"
#include "NetworkManager.hpp"
#include "PatternManager.hpp"
#include "AppGuardChecker.hpp"
#include "ResponseManager.hpp"
#include "IntegrityManager.hpp"
#include "JailbreakManager.hpp"
#include "SimulatorManager.hpp"
#include "ProcessCollector.hpp"
#include "SecurityEventHandler.h"
#include "AGResourceIntegrityManager.hpp"
#include "AGVPNDetectManager.hpp"

class __attribute__((visibility("hidden"))) ScanDispatcher {
public:
    void scan();
    void startScanThread();
    void wakeUpScanThread();

private:
    void scanFile();
    void scanProcess();
    void scanResourceIntegrity();
    void scanVpnNetwork();
    void MonitoringStart();

    bool jailbreakDevice_ = false;
    
    int scanSecond = 30;
    int firstSecond = 5;
    int firstExecute = 0xee;
    
    std::mutex scanStartMutex_;
    std::condition_variable scanStartCV_;
};
#endif /* ScanDispatcher_hpp */
