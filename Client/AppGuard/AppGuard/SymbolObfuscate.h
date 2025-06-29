//
//  SymbolObfuscate.h
//  AppGuard
//
//  Created by Junyeong on 2021/04/14.
//  Copyright © 2021 nhnent. All rights reserved.
//

#ifndef SymbolObfuscate_h
#define SymbolObfuscate_h

//#define APPGUARD_RELEASE
#ifdef APPGUARD_RELEASE



#define AppGuardCore Diresu
#define setSignerIntegrity f
#define checkSwizzled parseJsonSvrLog
#define checkCodeHashByAppGuard comparePathExtension
#define doAppGuard s
#define setCallback o
#define setAppGuardUnityCallback v
#define setUseAlert w
#define setUserName n
#define getDeviceID g
#define appGuardEncryption e
#define sslPinningCheck k
#define offDebugDetect t
#define forceExitWithAlert z


#define AppGuardCore2 ToastMemoryInformationManager
#define ptraceCheck initialize
#define dummy1 sendMemoryInformation
#define checkAppGuardRunning getMemoryInformation
#define detectTweak getMemoryStatus
#define checkAppGuardSwizzled  getStackInformation
#define dummy2 getRegisterInformation


#define AppGuardCore3 AGNController
#define sslPinningCheckk initialize
#define antiABypass startThread
#define checkTweak2 sendApplicationInfo
#define checkTweak3 removeApplicationInfo
#define checkTweak4 endThread


#define AppGuardCore4 RedSharkAnalyticsServices
#define antiIOSGod init
#define dummy3 setAnalyticsEvent
#define checkTweak5 setAnalyticsEventName
#define dummy4 setAnalyticsEventId
#define dummy5 setAnalyticsEventHandle
#define checkAppGuardHookk checkAnalyticsEvent
#define checkTweakk checkAnalyticsEventName
#define checkTweakk2 checkAnalyticsEventId
#define checkTweakk3 checkAnalyticsEventHandle
#define checkTweakk4 sendAnalyticsInformation


#define ProtectSelf RNCryptorLoader
#define checkAppGuardSwizzled2 load
#define doAppGuardAPI initWithOperations
#define setCallbackAPI addData
#define setUnityCallbackAPI removeData
#define useAlertAPI setResponseQueue
#define setUserNameAPI randomDataOfLength
#define appGuardEncAPI initWithHandler
#define sslPinningAPI error
#define offDebugDetectAPI read
#define forceExitWithAlertAPI write
#define freeAPI finish


#define AppGuardCoreBlinder Rednilb
#define protectContent t
#define protectSnapshot u

#endif /* APPGUARD_RELEASE */
#endif /* SymbolObfuscate_h */
