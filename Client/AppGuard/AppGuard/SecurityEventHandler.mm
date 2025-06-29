//
//  SecurityEventHandler.m
//  appguard-ios
//
//  Created by NHNEnt on 2016. 5. 4..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#import "SecurityEventHandler.h"
#import "AGAlertMonitor.h"

// 이전 방식의 콜백 탐지 코드를 위한 정의
// 하위 호환성을 위해 남겨둠
static const NSDictionary *kAGLagacyResponseType = @{
    [NSNumber numberWithInt:AGResponseTypeDetect] : @"R0",
    [NSNumber numberWithInt:AGResponseTypeBlock] : @"R1",
};

static const NSDictionary *kAGLagacyPatternNameCode = @{
    [NSNumber numberWithInt:AGPatternNameFreeUser] : @"BP1",
    [NSNumber numberWithInt:AGPatternNameIAPTweak] : @"BP0",
    [NSNumber numberWithInt:AGPatternNameDefaultCallback] : @"AP0",
    [NSNumber numberWithInt:AGPatternNameAppguardModification] : @"MP3",
    [NSNumber numberWithInt:AGPatternNameGameGuadian] : @"CP5",
    [NSNumber numberWithInt:AGPatternNameGameHacker] : @"CP0",
    [NSNumber numberWithInt:AGPatternNameNativeDebugger] : @"DP0",
    [NSNumber numberWithInt:AGPatternNameDebuggerGroup] : @"",
    [NSNumber numberWithInt:AGPatternNameGamePlayer] : @"CP1",
    [NSNumber numberWithInt:AGPatternNameFlex] : @"CP2",
    [NSNumber numberWithInt:AGPatternNameMemSearch] : @"CP3",
    [NSNumber numberWithInt:AGPatternNameCodeModification] : @"MP0",
    [NSNumber numberWithInt:AGPatternNameJailbreakGroup] : @"JP0",
    [NSNumber numberWithInt:AGPatternNameJailbreakActive] : @"JP1",
    [NSNumber numberWithInt:AGPatternNameGameGem] : @"CP4",
    [NSNumber numberWithInt:AGPatternNameIPAModification] : @"MP1",
    [NSNumber numberWithInt:AGPatternNameIPADecryption] : @"MP2",
    [NSNumber numberWithInt:AGPatternNameTweak] : @"CP6",
    [NSNumber numberWithInt:AGPatternNameBlackList] : @"BL0",
    [NSNumber numberWithInt:AGPatternNameJailedCheat] : @"CP7",
    [NSNumber numberWithInt:AGPatternNameSimulator] : @"SP0",
    [NSNumber numberWithInt:AGPatternNameCAPIHook] : @"HP0",
    [NSNumber numberWithInt:AGPatternNameObjcAPIHook] : @"HP1",
    [NSNumber numberWithInt:AGPatternNameUserFuntionHook] : @"HP2",
    [NSNumber numberWithInt:AGPatternNameSSLPinning] : @"NP0",
    [NSNumber numberWithInt:AGPatternNameAppGuardHook] : @"HP3",
};

static const NSDictionary *kAGLagacyPatternGroupCode = @{
    [NSNumber numberWithInt:AGPatternGroupRegisterCallback]: @"A0",
    [NSNumber numberWithInt:AGPatternGroupBehavior]: @"B0",
    [NSNumber numberWithInt:AGPatternGroupCheatingTool]:@"C0",
    [NSNumber numberWithInt:AGPatternGroupSimulator]: @"S0",
    [NSNumber numberWithInt:AGPatternGroupModification]: @"M0",
    [NSNumber numberWithInt:AGPatternGroupDebugger]:@"D0",
    [NSNumber numberWithInt:AGPatternGroupNetwork]: @"N0",
    [NSNumber numberWithInt:AGPatternGroupJailbreak]: @"J0",
    [NSNumber numberWithInt:AGPatternGroupHooking]: @"H0",
    [NSNumber numberWithInt:AGPatternGroupBlackList]: @"B1",
};

// 이전 탐지 코드 반환을 위한 함수
// 새롭게 추가된 Enum에 대해서는 Enum 정수 그대로 String리턴.
__attribute__((visibility("hidden"))) static NSString* getAGLagacyPatternGroupCode(AGPatternGroup patternGroup) {
    NSString* code = kAGLagacyPatternGroupCode[[NSNumber numberWithInt:patternGroup]];
    return code ? code : [@(patternGroup) stringValue];
}

__attribute__((visibility("hidden"))) static NSString* getAGLagacyPatternNameCode(AGPatternName patternName) {
    NSString* code = kAGLagacyPatternNameCode[[NSNumber numberWithInt:patternName]];
    return code ? code : [@(patternName) stringValue];
}

__attribute__((visibility("hidden"))) static NSString* getAGLagacyResponseCode(AGResponseType responseType) {
    NSString* code = kAGLagacyResponseType[[NSNumber numberWithInt:responseType]];
    return code ? code : [@(responseType) stringValue];
}


__attribute__((visibility("hidden"))) SecurityEventHandler::SecurityEventHandler()
{
    AGCallback = NULL;
    UnityCallback = NULL;
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::callUserCallback(NSString* msg) {
   
    if(AGCallback != NULL) {
        AGLog(@"Gneral Callback - [%@]", msg);
        NSLog(@"%s",SECURE_STRING(callback_json_field_deprecate_log));
        (*AGCallback)(NULL,NULL, msg);
    }
    
    if(UnityCallback != NULL) {
        const char* msgCStrng = NS2CString(msg);
        AGLog(@"Unity Callback - [%s]", msgCStrng);
        NSLog(@"%s",SECURE_STRING(callback_json_field_deprecate_log));
        UnityCallback(msgCStrng);
    }
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::throwSecurityEvent(DetectInfo* detectInfo) {
    
    NSData* detectJson = getDetectJson(detectInfo);
    callUserCallback([[NSString alloc] initWithData:detectJson encoding:NSUTF8StringEncoding]);

    if(detectInfo->responseType_ == AGResponseTypeBlock) { // 블럭 설정을 하였을 경우
        STInstance(AppGuardChecker)->setCheckBlockFlagC();
        if(useAlert_) { // 경고창을 사용할 경우
            AGLog(@"Do alert");
            doAlert(detectInfo); // 경고창 띄움
        } else {
            STInstance(AppGuardChecker)->setCheckBlockFlagD();
            STInstance(AppGuardChecker)->setCheckBlockFlagE();
            AGLog(@"Do Exit");
            STInstance(CommonAPI)->cSleepB(forceExitSecond);
            STInstance(ExitManager)->callExit(); // 종료
            makeCrash();
        }
    }
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::setObjcCallback(IMP function, bool useAlert)
{
    STInstance(EncryptionAPI)->setEncFlagA();
    AGCallback = (void(*)(id, SEL, NSString*))function;
    AGLog(@"Address : [%p]", AGCallback);
    useAlert_ = useAlert;
    
    if (useAlert_) {
        STInstance(AGAlertMonitor)->start();
    }
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::setUnityCallback(void* function, bool useAlert)
{
    STInstance(EncryptionAPI)->setEncFlagA();
    UnityCallback = reinterpret_cast<void (*)(const char*)>(function);
    AGLog(@"Address : [%p]", UnityCallback);
    useAlert_ = useAlert;
    
    if (useAlert_) {
        STInstance(AGAlertMonitor)->start();
    }
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::setAlert(bool useAlert)
{
    useAlert_ = useAlert;
    
    if (useAlert_) {
        STInstance(AGAlertMonitor)->start();
    }
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::callRegisterCallback()
{
    DetectInfo* detectInfo = new DetectInfo(0, AGPatternGroupRegisterCallback, AGPatternNameDefaultCallback, AGResponseTypeDetect, "");
    STInstance(DetectManager)->addDetectInfo(detectInfo);
    AGLog(@"Add default callback");
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::doAlert(DetectInfo* detectInfo)
{
    STInstance(AppGuardChecker)->setCheckBlockFlagD();
    static bool alreadyAlert = false;
    if(alreadyAlert)
    {
        AGLog(@"Already show");
        return;
    }
        
    AGLog(@"Alert detectCode code : [%d] [%d]", detectInfo->patternGroup_, detectInfo->patternName_);
    showAlertWindow(detectInfo);
    alreadyAlert = true;
//    if(useForceExit)
    AGLog(@"useForceExit is true");
    
    STInstance(CommonAPI)->cSleepB(forceExitSecond);
    
// exit을 호출하는 어셈블리코드 (추후 함수형태로 사용 시 inline attribute 를 사용할 것)
#if defined __arm64__ || defined __arm64e__
    __asm __volatile("mov x0, #0");
    __asm __volatile("mul x0, x0, x0");
    __asm __volatile("mov w1, #0");
    __asm __volatile("mov w2, #1");
    __asm __volatile("add w3, w2, w1");
    __asm __volatile("mov w16, w3");
    __asm __volatile("svc #0x80");
#endif
    
    STInstance(ExitManager)->callExit(); // 종료
    
//  위 exit 함수 및 어셈블리가 우회되는 경우 수 초 후 crash 발생
    STInstance(CommonAPI)->cSleepB(forceCrashSecond);
    makeCrash();
    
}

__attribute__((visibility("hidden"))) NSString* SecurityEventHandler::getDetectCode(DetectInfo* detectInfo) {
    return [NSString stringWithFormat:@"%d", detectInfo->patternGroup_ * 10000 + detectInfo->patternName_ ];
}

__attribute__((visibility("hidden"))) NSData* SecurityEventHandler::getDetectJson(DetectInfo* detectInfo) {
    
    NSMutableDictionary *detectJsonDict = [[NSMutableDictionary alloc] init];
   
    NSString* patternGroup = getAGLagacyPatternGroupCode(detectInfo->patternGroup_);
    NSString* patternName = getAGLagacyPatternNameCode(detectInfo->patternName_);
    NSString* response = getAGLagacyResponseCode(detectInfo->responseType_);
    AGLog(@"detect info - [%@] [%@] [%@]", patternGroup, patternName, response);

    [detectJsonDict setObject:response forKey:@"RT"];
    [detectJsonDict setObject:patternGroup forKey:@"PG"];
    [detectJsonDict setObject:patternName forKey:@"PN"];
    
    NSMutableDictionary *infoJsonDict = [[NSMutableDictionary alloc] init];
    [infoJsonDict setObject:[NSNumber numberWithInt:detectInfo->responseType_] forKey:@"type"];
    [infoJsonDict setObject:getDetectCode(detectInfo) forKey:@"data"];
    
    [detectJsonDict setObject:infoJsonDict forKey:@"info"];
    
    return [NSJSONSerialization dataWithJSONObject:detectJsonDict options:NSJSONWritingPrettyPrinted error:NULL];
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::showAlertWindow(DetectInfo *info)
{
    STInstance(AppGuardChecker)->setCheckBlockFlagE();
    STInstance(AGAlertMonitor)->setData(info->patternGroup_, info->patternName_);
}
__attribute__((visibility("hidden"))) bool SecurityEventHandler::getFreeAlert()
{
    return freeAlert_;
}

__attribute__((visibility("hidden"))) void SecurityEventHandler::setForceExit()
{
    useForceExit = true;
}

__attribute__((visibility("hidden"))) bool SecurityEventHandler::getForceExit()
{
    return useForceExit;
}
