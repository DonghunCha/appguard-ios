//
//  ScanDispatcher.cpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 5. 2..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include <chrono>
#include "ScanDispatcher.hpp"
#include "AGStatusMonitor.hpp"
#include "AGReactNativeManager.hpp"
#include "AGFlutterManager.hpp"
#include "AGMacroToolDetector.h"

__attribute__((visibility("hidden"))) void ScanDispatcher::wakeUpScanThread() {
    AGLog(@"wake up scan thread!");
    scanStartCV_.notify_one();
}

AG_PRIVATE_API void ScanDispatcher::MonitoringStart() {
    //정책 수신 후 시작한다.
    STInstance(AGMacroToolDetector)->Initailize();
}
__attribute__((visibility("hidden"))) void ScanDispatcher::startScanThread() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @try {
            STInstance(EncryptionAPI)->setEncFlagD();
            STInstance(AppGuardChecker)->setCheckScanFlagA();
       
            NSOperationQueue *scanQueue = [[NSOperationQueue alloc] init];
            [scanQueue addOperationWithBlock:^{
                AGLog(@"scan thread is start!!");
                STInstance(AppGuardChecker)->setCheckScanFlagB();
                std::unique_lock<std::mutex> lock(scanStartMutex_);
                while(true) {
                    @autoreleasepool {
                        if(firstExecute != 0xed) {
                            if([STInstance(EnvironmentManager)->getUserId() isEqual:@"unknown"]) {
                                scanStartCV_.wait_for(lock, std::chrono::seconds(firstSecond));
                            }
                            // Monitoring Start
                            MonitoringStart();
                            firstExecute = 0xed;
                        }
                        scan();
                        STInstance(CommonAPI)->stdSleepFor(scanSecond);
                    }
                }
            }];
        }
        @catch(NSException *exception) {
            AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
        }
    });
}

__attribute__((visibility("hidden"))) void ScanDispatcher::scan()
{
    STInstance(AppGuardChecker)->setCheckScanFlagC();
    scanFile();
    scanProcess();
    scanVpnNetwork();
    scanResourceIntegrity();
}

__attribute__((visibility("hidden"))) void ScanDispatcher::scanFile()
{
    AGLog(@"File scanning...");
    STInstance(AppGuardChecker)->setCheckScanFlagD();
    bool found = false;
    char* changeDetail = nullptr;
    
    auto filePatterns = STInstance(PatternManager)->getFilePatterns();
    unsigned long size = filePatterns.size();
    
    for (int idx = 0; idx < size; idx++)
    {
        found = false;
        changeDetail = nullptr;
        
        if(filePatterns[idx]->group_ == AGPatternGroupJailbreak)
        {
            if(filePatterns[idx]->checkType_ == kExist)
            {
                found = Util::checkFileExist(filePatterns[idx]->filePath_.c_str());

                if(found && filePatterns[idx]->index_ == 114)
                {
                    changeDetail = SECURE_STRING(Suspected_IAP_hacking);
                }
                
            }
            else if(filePatterns[idx]->checkType_ == kLink)
            {
                found = Util::checkFileSymlink(filePatterns[idx]->filePath_.c_str());
            }
        }
        else if(filePatterns[idx]->group_ == AGPatternGroupCheatingTool)
        {
            if(filePatterns[idx]->checkType_ == kContents)
            {
                char* DynamicLibraryPath = Util::checkDynamicLibrary(filePatterns[idx]->filePath_.c_str(), filePatterns[idx]->info1_.c_str(), filePatterns[idx]->info2_.c_str());
                if(DynamicLibraryPath != NULL)
                {
                    changeDetail = DynamicLibraryPath;
                    found = true;
                }
            }else if(filePatterns[idx]->checkType_ == kExist)
            {
                if(filePatterns[idx]->name_ == AGPatternNameJailedCheat)
                {
                    NSString* targetPath = Util::getBundlePath();
                    targetPath = [targetPath stringByAppendingString:C2NSString(filePatterns[idx]->filePath_.c_str())];
                    if(Util::checkFileExist(NS2CString(targetPath)))
                    {
                        found = true;
                    }
                }
            }
        }
        else if(filePatterns[idx]->group_ == AGPatternGroupBehavior) // 모니터링
        {
            if(filePatterns[idx]->checkType_ == kContents)
            {
                char* DynamicLibraryPath = Util::checkDynamicLibrary(filePatterns[idx]->filePath_.c_str(), filePatterns[idx]->info1_.c_str(), filePatterns[idx]->info2_.c_str());
                if(DynamicLibraryPath != NULL)
                {
                    changeDetail = DynamicLibraryPath;
                    found = true;
                }
            }
        }
        
        if(found)
        {
            if(filePatterns[idx]->group_ == AGPatternGroupJailbreak)
            {
                jailbreakDevice_ = true;
            }
            
            if(changeDetail != nullptr)
            {
                STInstance(DetectManager)->addDetectInfo(filePatterns[idx]->index_, filePatterns[idx]->group_, filePatterns[idx]->name_, filePatterns[idx]->response_, changeDetail);
            }
            else
            {
                STInstance(DetectManager)->addDetectInfo(filePatterns[idx]->index_, filePatterns[idx]->group_, filePatterns[idx]->name_, filePatterns[idx]->response_, filePatterns[idx]->filePath_.c_str());
            }
            
            if(filePatterns[idx]->response_ == AGResponseTypeBlock) {
                STInstance(AGStatusMonitor)->setBlockDetectedStatus(filePatterns[idx]->index_, filePatterns[idx]->group_, filePatterns[idx]->name_, filePatterns[idx]->response_, changeDetail ? changeDetail : filePatterns[idx]->filePath_.c_str());
            }
            
            AGLog(@"File detected - index : [%d]", filePatterns[idx]->index_);
        }
    }
}

__attribute__((visibility("hidden"))) void ScanDispatcher::scanProcess()
{
    AGLog(@"Process scanning...");
    STInstance(AppGuardChecker)->setCheckScanFlagE();
    bool found = false;
    char* changeDetail = nullptr;
    
    auto procPatterns = STInstance(PatternManager)->getProcPatterns();
    unsigned long size = procPatterns.size();
    
    for (int idx = 0; idx < size; idx++)
    {
        found = false;
        changeDetail = nullptr;
        
        if(procPatterns[idx]->group_ == AGPatternGroupJailbreak)
        {
            if(procPatterns[idx]->checkType_ == kSandBox)
            {
                found = STInstance(JailbreakManager)->checkSandbox();
            }
            else if(procPatterns[idx]->checkType_ == kDyld)
            {
                found = STInstance(JailbreakManager)->checkDyld(procPatterns[idx]->processName_.c_str());
            }
            else if(procPatterns[idx]->checkType_ == kDirectoryPermission)
            {
                found = STInstance(JailbreakManager)->checkDirectoryPermission();
            }
            else if(procPatterns[idx]->checkType_ == kInsertLib)
            {
                found = STInstance(JailbreakManager)->checkInsertLib(procPatterns[idx]->processName_.c_str());
            }
            else if(procPatterns[idx]->checkType_ == kClass)
            {
                found = STInstance(JailbreakManager)->checkClass(procPatterns[idx]->processName_.c_str());
            }
            else if(procPatterns[idx]->checkType_ == kInject)
            {
                found = STInstance(JailbreakManager)->checkInject(procPatterns[idx]->processName_.c_str());
            }
            else if(procPatterns[idx]->checkType_ == kJailbreakTest)
            {
                found = STInstance(JailbreakManager)->detectTest();
            }
        }
        else if(procPatterns[idx]->group_ == AGPatternGroupDebugger)
        {
            if(procPatterns[idx]->checkType_ == kDebugInfo)
            {
                found = STInstance(DebugManager)->checkDebugger();
            }
            else if(procPatterns[idx]->checkType_ == kDebugTTY)
            {
                found = STInstance(DebugManager)->checkIsatty();
            }
//            if(!found)
//            {
//                STInstance(DebugManager)->ptracePtr();
//            }
        }
        else if(procPatterns[idx]->group_ == AGPatternGroupModification)
        {
            if(procPatterns[idx]->checkType_ == kTextMemory)
            {
                found = STInstance(IntegrityManager)->checkTextSectionHash() ||
                STInstance(IntegrityManager)->checkTextSectionHashByProtector() ||
                STInstance(IntegrityManager)->checkUnityFramework();
            }
            else if(procPatterns[idx]->checkType_ == kSignatrueHash)
            {
                found = STInstance(IntegrityManager)->checkCodeSignatureHash();
            }
            else if(procPatterns[idx]->checkType_ == kSigner){
                changeDetail = (char*)STInstance(IntegrityManager)->checkSigner();
                if(changeDetail != nullptr){
                    AGLog(@"changeDetail is %s", changeDetail);
                    found = true;
                }
            }
            else if(procPatterns[idx]->checkType_ == kDyld){
                found = (char*)STInstance(IntegrityManager)->checkDylibInjection();
            } else if(procPatterns[idx]->checkType_ == kReactNativeJsBundle) {
                found = !STInstance(AGReactNativeManager)->GetIntegrityCheck();
                if(found) {
                    NSString* detail = [NSString stringWithFormat:@"%s %@", procPatterns[idx]->processName_.c_str(), STInstance(AGReactNativeManager)->GetEngineHeaderInfoString()];
                    changeDetail = (char*)NS2CString(detail);
                    AGLog(@"React Native mod detail %@", detail);
                }
            } else if(procPatterns[idx]->checkType_ == kFlutterIntegrity) {
                bool isInvalidAppFramework = !STInstance(AGFlutterManager)->CheckAppFrameworkIntegrity();
                bool isInvalidFlutterFramework = !STInstance(AGFlutterManager)->CheckFlutterFrameworkIntegrity();
                found = isInvalidAppFramework | isInvalidFlutterFramework;
                if(found) {
                    NSString* detail = [NSString stringWithFormat:@"%s %@ %d %d", procPatterns[idx]->processName_.c_str(), NS_SECURE_STRING(string_Flutter), isInvalidAppFramework, isInvalidFlutterFramework];
                    changeDetail = (char*)NS2CString(detail);
                    AGLog(@"Flutter Native mod detail %@", detail);
                }
            }
        }
        else if(procPatterns[idx]->group_ == AGPatternGroupSimulator)
        {
            if(procPatterns[idx]->checkType_ == kSimulatorTarget)
            {
                found = STInstance(SimulatorManager)->checkTarget();
            }
            else if(procPatterns[idx]->checkType_ == kHardwareMachine)
            {
                found = STInstance(SimulatorManager)->checkMachine();
            }
        }
        else if(procPatterns[idx]->group_ == AGPatternGroupHooking)
        {
            if(procPatterns[idx]->checkType_ == kCAPI)
            {
                NSString* result = @"";
                
                changeDetail = STInstance(HookManager)->checkSystemAPIHook();
                if(STInstance(CommonAPI)->cStrcmp(changeDetail, "H") != 0 && changeDetail != nullptr)
                {
                    found = true;
                }
                result = [result stringByAppendingFormat:@"%s", changeDetail];
                
                changeDetail = STInstance(HookManager)->checkValidSvcCallHook();
                if(STInstance(CommonAPI)->cStrcmp(changeDetail, "SH") != 0 && changeDetail != nullptr)
                {
                    found = true;
                }
                result = [result stringByAppendingFormat:@"%s", changeDetail];
                
                changeDetail = (char*)NS2CString(result);
            }
            else if(procPatterns[idx]->checkType_ == kObjCAPI)
            {
                changeDetail = STInstance(HookManager)->checkObjCAPIHook();
                if(changeDetail != nullptr)
                {
                    found = true;
                }
            }
            else if(procPatterns[idx]->checkType_ == kAGAPI)
            {
                changeDetail = STInstance(HookManager)->checkAppGuardAPIHook();
                if(changeDetail != nullptr)
                {
                    found = true;
                }
            }
        }
        else if(procPatterns[idx]->group_ == AGPatternGroupNetwork)
        {
            if(procPatterns[idx]->checkType_ == kSSL)
            {
                changeDetail = STInstance(NetworkManager)->getPinningValue();
                if(changeDetail != nullptr)
                {
                    found = true;
                }
            }
        }
        else if(procPatterns[idx]->group_ == AGPatternGroupBehavior)
        {
            if(procPatterns[idx]->checkType_ == kEnv)
            {
                found = STInstance(JailbreakManager)->checkEnv(procPatterns[idx]->processName_.c_str());
            }
        }
        
        if(found)
        {
            if(procPatterns[idx]->group_ == AGPatternGroupJailbreak)
            {
                jailbreakDevice_ = true;
            }
            
            if(changeDetail != nullptr)
            {
                STInstance(DetectManager)->addDetectInfo(procPatterns[idx]->index_, procPatterns[idx]->group_, procPatterns[idx]->name_, procPatterns[idx]->response_, changeDetail);
            }
            else
            {
                STInstance(DetectManager)->addDetectInfo(procPatterns[idx]->index_, procPatterns[idx]->group_, procPatterns[idx]->name_, procPatterns[idx]->response_, procPatterns[idx]->processName_.c_str());
            }
            
            if(procPatterns[idx]->response_ == AGResponseTypeBlock) {
                STInstance(AGStatusMonitor)->setBlockDetectedStatus(procPatterns[idx]->index_, procPatterns[idx]->group_, procPatterns[idx]->name_, procPatterns[idx]->response_, changeDetail ? changeDetail : procPatterns[idx]->processName_.c_str());
            }
            
            AGLog(@"Process detected - index : [%d]", procPatterns[idx]->index_);
        }
    }
}


__attribute__((visibility("hidden"))) void ScanDispatcher::scanResourceIntegrity() {
    AGLog(@"Resource Integrity scanning...");
    STInstance(AppGuardChecker)->setCheckScanFlagH();
    bool found = false;
    

    auto resourceIntegrityPatterns = STInstance(PatternManager)->getResourceIntegrityPatterns();
    unsigned long size = resourceIntegrityPatterns.size();
   
    for (int idx = 0; idx < size; idx++) {
        NSString* detail = nil;
        if(resourceIntegrityPatterns[idx]->group_ == AGPatternGroupModification) {
            if(resourceIntegrityPatterns[idx]->name_ == AGPatternNameInfoPlistModification) {
                NSString* infoPlistOriginalString = nil;
                found = STInstance(AGResourceIntegrityManager)->checkInfoPlist(&infoPlistOriginalString);
                detail = [NSString stringWithFormat:@"%s(%@)", resourceIntegrityPatterns[idx]->getResourceSubPath().c_str(), infoPlistOriginalString];
            }
        }
        
        if(found) {
            STInstance(DetectManager)->addDetectInfo(resourceIntegrityPatterns[idx]->index_, resourceIntegrityPatterns[idx]->group_, resourceIntegrityPatterns[idx]->name_, resourceIntegrityPatterns[idx]->response_, NS2CString(detail));
        }
    }

  
}


void ScanDispatcher::scanVpnNetwork() {
    
    AGLog(@"Vpn network scanning...");
    std::vector<NSString*> vpnInterfaces;
    if(!STInstance(AGVPNDetectManager)->IsVPNNetwork(&vpnInterfaces))
    {
        return;
    }
    
    auto vpnDetectionPatterns = STInstance(PatternManager)->getVPNDetectionPatterns();
    if(vpnDetectionPatterns.size() == 0)
    {
        return;
    }
    
    NSMutableString* detail = [[NSMutableString alloc] init];
    for(auto interfacename : vpnInterfaces)
    {
        [detail appendFormat:@"%@ ", interfacename];
    }
    
    STInstance(DetectManager)->addDetectInfo(vpnDetectionPatterns[0]->index_,
                                             vpnDetectionPatterns[0]->group_,
                                             vpnDetectionPatterns[0]->name_,
                                             vpnDetectionPatterns[0]->response_,
                                             NS2CString(detail));
    
    if(vpnDetectionPatterns[0]->response_ == AGResponseTypeBlock) {
        STInstance(AGStatusMonitor)->setBlockDetectedStatus(vpnDetectionPatterns[0]->index_,
                                                            vpnDetectionPatterns[0]->group_,
                                                            vpnDetectionPatterns[0]->name_,
                                                            vpnDetectionPatterns[0]->response_,
                                                            NS2CString(detail));
    }
    
}
