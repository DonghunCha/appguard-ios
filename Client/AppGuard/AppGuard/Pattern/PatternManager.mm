//
//  PatternManager.cpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "AGCommon.hpp"
#include "PatternManager.hpp"

#define AG_PATTERN_VERSION "iOS_REAL_5.2" //특별히 의미하는 바는 없음. 정책이 추가될 때 올림.

AG_PRIVATE_API PatternManager::PatternManager():
jailbreak_( AGResponseTypeDetect),
cheating_(AGResponseTypeDetect),
debugger_(AGResponseTypeDetect),
modification_(AGResponseTypeDetect),
simulator_ (AGResponseTypeDetect),
hook_ (AGResponseTypeDetect),
network_(AGResponseTypeDetect),
locationSpoof_(AGResponseTypeDetect),
screenCapture_(AGResponseTypeDetect),
screenRecord_(AGResponseTypeDetect)
{
    patternVersion_ = AG_PATTERN_VERSION;
    AGLog(@"Pattern Version - [%s]", patternVersion_.c_str());
}

AG_PRIVATE_API PatternManager::~PatternManager()
{
    releasePatterns();
}

AG_PRIVATE_API void PatternManager::setVersion(std::string version) {
    patternVersion_ = version;
}

AG_PRIVATE_API std::string PatternManager::getVersion()
{
    return patternVersion_;
}

AG_PRIVATE_API void PatternManager::initPatterns()
{
    STInstance(EncryptionAPI)->setEncFlagB();
    STInstance(AppGuardChecker)->setCheckFlagB();
    initFilePatterns();
    initProcPatterns();
    initResourceIntegrityPatterns();
    initLocationSpoofPatterns();
    initScreenRecordPatterns();
    initScreenCapturePatterns();
    initVPNDetectionPatterns();
    initMacroToolPatterns();
}

AG_PRIVATE_API void PatternManager::initScreenRecordPatterns() {
    screenRecordPatterns_.push_back(new Pattern(1801, AGPatternGroupScreenRecord, AGPatternNameScreenRecord, AGResponseTypeDetect));
}

AG_PRIVATE_API void PatternManager::initScreenCapturePatterns() {
    screenCapturePatterns_.push_back(new Pattern(1850, AGPatternGroupScreenCapture, AGPatternNameScreenCapture, AGResponseTypeDetect));
}

AG_PRIVATE_API void PatternManager::initVPNDetectionPatterns() {
    VPNDetectionPatterns_.push_back(new Pattern(1870, AGPatternGroupVPN, AGPatternNameVPNConnection, AGResponseTypeDetect));
}

AG_PRIVATE_API void PatternManager::initMacroToolPatterns() {
    macroToolPatterns_.push_back(new Pattern(1900, AGPatternGroupMacroTool, AGPatternNameSwitchControl, AGResponseTypeDetect));
}

AG_PRIVATE_API void PatternManager::initFilePatterns()
{
    /*
     Jailbreak (101 ~ 199)
    */
    filePatterns_.push_back( new FilePattern(Pattern(101, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(Cydia_app)));
    filePatterns_.push_back( new FilePattern(Pattern(102, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(apt)));
    filePatterns_.push_back( new FilePattern(Pattern(103, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(cydia_log)));
    filePatterns_.push_back( new FilePattern(Pattern(104, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(lib_cydia)));
    filePatterns_.push_back( new FilePattern(Pattern(105, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup,  AGResponseTypeDetect),  kLink, SECURE_STRING(applications)));
    filePatterns_.push_back( new FilePattern(Pattern(106, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(MobileSubstrate_dylib_path)));
    filePatterns_.push_back( new FilePattern(Pattern(107, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_var_cache_apt)));
    filePatterns_.push_back( new FilePattern(Pattern(108, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_var_lib_apt)));
    filePatterns_.push_back( new FilePattern(Pattern(109, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_var_lib_cydia)));
    filePatterns_.push_back( new FilePattern(Pattern(110, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(stash)));
    filePatterns_.push_back( new FilePattern(Pattern(111, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_var_log_syslog)));
    filePatterns_.push_back( new FilePattern(Pattern(112, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_var_tmp_cydia_log)));
    filePatterns_.push_back( new FilePattern(Pattern(113, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_etc_apt)));
    filePatterns_.push_back( new FilePattern(Pattern(114, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(iapCracker_plist)));
    filePatterns_.push_back( new FilePattern(Pattern(115, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(AdaptiveHome_dylib)));
    filePatterns_.push_back( new FilePattern(Pattern(116, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(Sileo_Nightly_app)));
    filePatterns_.push_back( new FilePattern(Pattern(117, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(Zebra_app)));
    filePatterns_.push_back( new FilePattern(Pattern(118, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kLink, SECURE_STRING(_var_jb_path)));
    filePatterns_.push_back( new FilePattern(Pattern(119, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_application_sileoapp_path)));
    filePatterns_.push_back( new FilePattern(Pattern(120, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_cores_binback_application_palera1nloader_app)));
    filePatterns_.push_back( new FilePattern(Pattern(121, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kExist, SECURE_STRING(_var_mobile_library_palera1n_helper)));
    if(!STInstance(SimulatorManager)->checkTarget())
    {
        filePatterns_.push_back( new FilePattern(Pattern(134, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kExist, SECURE_STRING(sbin_sshd)));
        filePatterns_.push_back( new FilePattern(Pattern(135, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kExist, SECURE_STRING(bin_sshd)));
        filePatterns_.push_back( new FilePattern(Pattern(136, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kExist, SECURE_STRING(sftp_server)));
        filePatterns_.push_back( new FilePattern(Pattern(137, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kExist, SECURE_STRING(_bin_bash)));
        filePatterns_.push_back( new FilePattern(Pattern(138, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kExist, SECURE_STRING(_bin_sh)));
        filePatterns_.push_back( new FilePattern(Pattern(139, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kExist, SECURE_STRING(_usr_sbin_sshd)));
        filePatterns_.push_back( new FilePattern(Pattern(140, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kExist, SECURE_STRING(ssh_keysign)));
        filePatterns_.push_back( new FilePattern(Pattern(141, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kExist, SECURE_STRING(sshd_config)));
    }
    
    /*
    Cheating Tool (201 ~ 299)
    */
    filePatterns_.push_back( new FilePattern(Pattern(201, AGPatternGroupCheatingTool, AGPatternNameTweak, AGResponseTypeDetect), kContents,
                                            SECURE_STRING(dynamic_libraries),
                                            STInstance(EnvironmentManager)->getPackageInfo().c_str(),
                                            SECURE_STRING(plist)));
    filePatterns_.push_back( new FilePattern(Pattern(202, AGPatternGroupCheatingTool, AGPatternNameJailedCheat, AGResponseTypeDetect), kExist, SECURE_STRING(substrate_binary_path)));
    
    /*
    Debugger (301 ~ 399)
    */
    
    /*
    Modification (401 ~ 499)
    */
    
    /*
    Simulator (501 ~ 599)
    */
    
    /*
    Behavior (601 ~ 699)
    */
    filePatterns_.push_back(new FilePattern(Pattern(601, AGPatternGroupBehavior, AGPatternNameIAPTweak, AGResponseTypeDetect), kContents,
                                            SECURE_STRING(dynamic_libraries),
                                            SECURE_STRING(com_apple_storekit),
                                            SECURE_STRING(plist)));
    
    AGLog(@"Initialize file patterns");
}

AG_PRIVATE_API void PatternManager::initProcPatterns()
{
    /*
    Jailbreak (1101 ~ 1199)
    */
    procPatterns_.push_back( new ProcPattern(Pattern(1101, AGPatternGroupJailbreak, AGPatternNameJailbreakGroup, AGResponseTypeDetect), kSandBox,    SECURE_STRING(sandbox_detected)));
    procPatterns_.push_back( new ProcPattern(Pattern(1102, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kDirectoryPermission, SECURE_STRING(temp_ag_file)));
    procPatterns_.push_back( new ProcPattern(Pattern(1103, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kDyld,      SECURE_STRING(MobileSubstrate_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1104, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kDyld,      SECURE_STRING(libsubstrate_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1105, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kDyld,      SECURE_STRING(TweakInject_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1106, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kDyld,      SECURE_STRING(SubstrateLoader_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1107, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kDyld,      SECURE_STRING(CydiaSubstrate)));
    procPatterns_.push_back( new ProcPattern(Pattern(1108, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kInsertLib, SECURE_STRING(MobileSubstrate_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1109, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kInsertLib, SECURE_STRING(libsubstrate_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1110, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kInsertLib, SECURE_STRING(TweakInject_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1111, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kInsertLib, SECURE_STRING(SubstrateLoader_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1112, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kInsertLib, SECURE_STRING(CydiaSubstrate)));
    procPatterns_.push_back( new ProcPattern(Pattern(1113, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kClass,     SECURE_STRING(AQPattern)));
    procPatterns_.push_back( new ProcPattern(Pattern(1114, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kInject,    SECURE_STRING(_Z12hookingSVC80v)));
    procPatterns_.push_back( new ProcPattern(Pattern(1115, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kEnv,       SECURE_STRING(_MSSafeMode)));
    procPatterns_.push_back( new ProcPattern(Pattern(1116, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kEnv,       SECURE_STRING(substitute)));
    procPatterns_.push_back( new ProcPattern(Pattern(1117, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kJailbreakTest, SECURE_STRING(NHN_JB_TEST)));
    procPatterns_.push_back( new ProcPattern(Pattern(1118, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kDyld,      SECURE_STRING(substitute_loader_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1119, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kInsertLib,      SECURE_STRING(substitute_loader_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1120, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kDyld,      SECURE_STRING(libsubstitute_dylib)));
    procPatterns_.push_back( new ProcPattern(Pattern(1121, AGPatternGroupJailbreak, AGPatternNameJailbreakActive, AGResponseTypeDetect), kInsertLib,      SECURE_STRING(libsubstitute_dylib)));
    /*
    Cheating Tool (1201 ~ 1299)
    */
    procPatterns_.push_back( new ProcPattern(Pattern(1201, AGPatternGroupCheatingTool, AGPatternNameGameHacker, AGResponseTypeDetect), kExecProcess,   SECURE_STRING(gamehacker)));
    procPatterns_.push_back( new ProcPattern(Pattern(1202, AGPatternGroupCheatingTool, AGPatternNameGamePlayer, AGResponseTypeDetect), kExecProcess,   SECURE_STRING(gameplayerd)));
    procPatterns_.push_back( new ProcPattern(Pattern(1203, AGPatternGroupCheatingTool, AGPatternNameFlex, AGResponseTypeDetect), kExecProcess,         SECURE_STRING(flex)));
    procPatterns_.push_back( new ProcPattern(Pattern(1204, AGPatternGroupCheatingTool, AGPatternNameMemSearch, AGResponseTypeDetect), kExecProcess,    SECURE_STRING(memsearch)));
    procPatterns_.push_back( new ProcPattern(Pattern(1205, AGPatternGroupCheatingTool, AGPatternNameGameGem, AGResponseTypeDetect), kExecProcess,      SECURE_STRING(gamegemios)));
    procPatterns_.push_back( new ProcPattern(Pattern(1206, AGPatternGroupCheatingTool, AGPatternNameGameGuadian, AGResponseTypeDetect), kExecProcess, SECURE_STRING(igameguardian)));
    
    /*
    Debugger (1301 ~ 1399)
    */
    if(debugOn)
    {
        procPatterns_.push_back( new ProcPattern(Pattern(1301, AGPatternGroupDebugger, AGPatternNameNativeDebugger, AGResponseTypeDetect), kDebugInfo, SECURE_STRING(debugger)));
        procPatterns_.push_back( new ProcPattern(Pattern(1302, AGPatternGroupDebugger, AGPatternNameNativeDebugger, AGResponseTypeDetect), kDebugTTY,  SECURE_STRING(isatty)));
    }
    
    /*
    Modification (1401 ~ 1499)
    */
    procPatterns_.push_back(new ProcPattern(Pattern(1401, AGPatternGroupModification, AGPatternNameCodeModification, AGResponseTypeDetect), kTextMemory,         SECURE_STRING(text_integrity)));
    procPatterns_.push_back(new ProcPattern(Pattern(1402, AGPatternGroupModification, AGPatternNameIPAModification, AGResponseTypeDetect), kSignatrueHash, SECURE_STRING(signature_integrity)));
    procPatterns_.push_back(new ProcPattern(Pattern(1403, AGPatternGroupModification, AGPatternNameIPAModification, AGResponseTypeDetect), kSigner,        SECURE_STRING(signer_integrity)));
    procPatterns_.push_back(new ProcPattern(Pattern(1404, AGPatternGroupModification, AGPatternNameIPAModification, AGResponseTypeDetect), kDyld,        SECURE_STRING(dylib_injection)));
    procPatterns_.push_back(new ProcPattern(Pattern(1405, AGPatternGroupModification, AGPatternNameCodeModification, AGResponseTypeDetect), kReactNativeJsBundle, SECURE_STRING(string_jsbundle)));
    procPatterns_.push_back(new ProcPattern(Pattern(1406, AGPatternGroupModification, AGPatternNameCodeModification, AGResponseTypeDetect), kFlutterIntegrity, SECURE_STRING(string_Flutter)));
    
    //procPatterns_.push_back(new ProcPattern(Pattern(1403, kModification, kCryptId, AGResponseTypeDetect), kProcessIntegrity, SECURE_STRING(cryptid))); // 오탐 발생
    // 1404 - 앱가드 우회 AppGuardCheck에서 사용
    
    /*
    Simulator (1501 ~ 1599)
    */
    procPatterns_.push_back(new ProcPattern(Pattern(1501, AGPatternGroupSimulator, AGPatternNameSimulator, AGResponseTypeDetect), kSimulatorTarget, SECURE_STRING(Debug_Target)));
    procPatterns_.push_back(new ProcPattern(Pattern(1502, AGPatternGroupSimulator, AGPatternNameSimulator, AGResponseTypeDetect), kHardwareMachine, SECURE_STRING(Debug_Machine_Info)));
    
    /*
    Hook (1601 ~ 1699)
    */
    procPatterns_.push_back(new ProcPattern(Pattern(1601, AGPatternGroupHooking, AGPatternNameCAPIHook, AGResponseTypeDetect), kCAPI, ""));
    procPatterns_.push_back(new ProcPattern(Pattern(1602, AGPatternGroupHooking, AGPatternNameObjcAPIHook, AGResponseTypeDetect), kObjCAPI, ""));
    // 1603 user function hook
    procPatterns_.push_back(new ProcPattern(Pattern(1604, AGPatternGroupHooking, AGPatternNameAppGuardHook, AGResponseTypeDetect), kAGAPI, ""));
    
    /*
    Network (1701 ~ 1799)
    */
    procPatterns_.push_back(new ProcPattern(Pattern(1701, AGPatternGroupNetwork, AGPatternNameSSLPinning, AGResponseTypeOff), kSSL, SECURE_STRING(SSLPinning)));
    
    /*
    Behavior (1801 ~ 1899)
    */
        
    AGLog(@"Initialize process patterns");
}

AG_PRIVATE_API void PatternManager::initResourceIntegrityPatterns() {
    
    resourceIntegrityPattern_.push_back(new AGResourceIntegrityPattern(Pattern(4000, AGPatternGroupModification, AGPatternNameInfoPlistModification, AGResponseTypeDetect), AGResourceIntegrityPatternCheckTypePlistInfo, SECURE_STRING(info_plist)));
    
    AGLog(@"Initialize Resource Integrity patterns");
}

AG_PRIVATE_API void PatternManager::initLocationSpoofPatterns() {
    
    locationSpoofPatterns_.push_back(new AGLocationSpoofPattern(Pattern(5000, AGPatternGroupLocationSpoofing, AGPatternNameMockLocation, AGResponseTypeDetect), AGLocationSpoofPatternCheckTypeAntiSpoof));
    
    AGLog(@"Initialize Fake Location patterns");
}

AG_PRIVATE_API void PatternManager::releasePatterns()
{
    int idx = 0;
    unsigned long size = filePatterns_.size();
    
    for (idx = 0; idx < size; idx++)
    {
        delete filePatterns_[idx];
    }
    
    size = procPatterns_.size();
    for (idx = 0; idx < size; idx++)
    {
        delete procPatterns_[idx];
    }
    
    size = resourceIntegrityPattern_.size();
    for (idx = 0; idx < size; idx++)
    {
        delete resourceIntegrityPattern_[idx];
    }
    
    size = locationSpoofPatterns_.size();
    for (idx = 0; idx < size; idx++)
    {
        delete locationSpoofPatterns_[idx];
    }
    
    size = screenCapturePatterns_.size();
    for (idx = 0; idx < size; idx++)
    {
        delete screenCapturePatterns_[idx];
    }
    
    size = screenRecordPatterns_.size();
    for (idx = 0; idx < size; idx++)
    {
        delete screenRecordPatterns_[idx];
    }
    
    AGLog(@"Release patterns");
}

AG_PRIVATE_API std::vector<FilePattern*>& PatternManager::getFilePatterns()
{
    STInstance(AppGuardChecker)->setCheckScanFlagF();
    return filePatterns_;
}

AG_PRIVATE_API std::vector<ProcPattern*>& PatternManager::getProcPatterns()
{
    STInstance(AppGuardChecker)->setCheckScanFlagG();
    return procPatterns_;
}

AG_PRIVATE_API
std::vector<AGLocationSpoofPattern*>& PatternManager::getLocationSpoofPatterns()
{
    return locationSpoofPatterns_;
}

AG_PRIVATE_API std::vector<AGResourceIntegrityPattern*>& PatternManager::getResourceIntegrityPatterns()
{
    return resourceIntegrityPattern_;
}

AG_PRIVATE_API std::vector<Pattern*>& PatternManager::getScreenCapturePatterns() {
    return screenCapturePatterns_;
}

AG_PRIVATE_API std::vector<Pattern*>& PatternManager::getScreenRecordPatterns() {
    return screenRecordPatterns_;
}

AG_PRIVATE_API std::vector<Pattern*>& PatternManager::getVPNDetectionPatterns() {
    return VPNDetectionPatterns_;
}

AG_PRIVATE_API std::vector<Pattern*>& PatternManager::getMacroToolPatterns() {
    return macroToolPatterns_;
}

//TODO : 불필요한 인자 증가. map과 같은 형태로 개선 가능?
AG_PRIVATE_API void PatternManager::setResponse(
                                 AGResponseType jailbreak,
                                 AGResponseType cheating,
                                 AGResponseType debugger,
                                 AGResponseType modification,
                                 AGResponseType simulator,
                                 AGResponseType hook,
                                 AGResponseType network,
                                 AGResponseType location,
                                 AGResponseType screenCapture,
                                 AGResponseType screenRecord,
                                 AGResponseType macroTool,
                                 AGResponseType vpnDetection
                                 ) {
    
    setResponseType(jailbreak,
                    cheating,
                    debugger,
                    modification,
                    simulator,
                    hook,
                    network,
                    location,
                    screenCapture,
                    screenRecord,
                    macroTool,
                    vpnDetection
                    );

    
    setResponseFilePattern();
    setResponseProcPattern();
    setResponseResourceIntegrityPattern();
    setResponseLocationSpoofPattern();
    setResponseScreenRecord();
    setResponseScreenCapture();
    setResponseVPNDetection();
    setResponseMacroTool();

}

AG_PRIVATE_API void PatternManager::setResponseType(
                                     AGResponseType jailbreak,
                                     AGResponseType cheating,
                                     AGResponseType debugger,
                                     AGResponseType modification,
                                     AGResponseType simulator,
                                     AGResponseType hook,
                                     AGResponseType network,
                                     AGResponseType location,
                                     AGResponseType screenCapture,
                                     AGResponseType screenRecord,
                                     AGResponseType macroTool,
                                     AGResponseType vpnDetection
                                     )
{
    setResponseTypeOfJailbreak(jailbreak);
    setResponseTypeOfCheating(cheating);
    setResponseTypeOfDebugger(debugger);
    setResponseTypeOfModification(modification);
    setResponseTypeOfSimulator(simulator);
    setResponseTypeOfHook(hook);
    setResponseTypeOfNetwork(network);
    setResponseTypeOfLocationSpoof(location);
    setResponseTypeOfScreenRecord(screenRecord);
    setResponseTypeOfScreenCapture(screenCapture);
    setResponseTypeOfVPNDetection(vpnDetection);
    setResponseTypeOfMacroTool(macroTool);
}





// @author  : daejoon kim
// @param   : 정책에 따른 리스폰 타입
// @brief   : 파일 패턴의 리스폰 타입을 변경
AG_PRIVATE_API void PatternManager::setResponseFilePattern()
{
    unsigned long filePatternSize = filePatterns_.size();
    if(filePatternSize != 0)
    {
        for (int idx = 0; idx < filePatternSize; idx++)
        {
            if (filePatterns_[idx]->group_ == AGPatternGroupJailbreak)
            {
                if(filePatterns_[idx]->name_ == AGPatternNameJailbreakGroup && jailbreak_ == AGResponseTypeBlock)
                {
                    continue; // 탈옥의심 차단 예외처리
                }
                filePatterns_[idx]->response_ = jailbreak_;
            }
            else if(filePatterns_[idx]->group_ == AGPatternGroupCheatingTool)
            {
                filePatterns_[idx]->response_ = cheating_;
            }
            else if(filePatterns_[idx]->group_ == AGPatternGroupDebugger)
            {
                filePatterns_[idx]->response_ = debugger_;
            }
            else if(filePatterns_[idx]->group_ == AGPatternGroupModification)
            {
                filePatterns_[idx]->response_ = modification_;
            }
            else if(filePatterns_[idx]->group_ == AGPatternGroupSimulator)
            {
                filePatterns_[idx]->response_ = simulator_;
            }
            else if(filePatterns_[idx]->group_ == AGPatternGroupHooking)
            {
                filePatterns_[idx]->response_ = hook_;
            }
            else if(filePatterns_[idx]->group_ == AGPatternGroupNetwork)
            {
                filePatterns_[idx]->response_ = network_;
            }
        }
    }
    AGLog(@"Set response - file patterns");
}

// @author  : daejoon kim
// @param   : 정책에 따른 리스폰 타입
// @brief   : 프로세스 패턴의 리스폰 타입을 변경
AG_PRIVATE_API void PatternManager::setResponseProcPattern()
{
    unsigned long procPatternSize = procPatterns_.size();
    if(procPatternSize != 0)
    {
        for (int idx = 0; idx < procPatternSize; idx++)
        {
            if (procPatterns_[idx]->group_ == AGPatternGroupJailbreak)
            {
                if(procPatterns_[idx]->name_ == AGPatternNameJailbreakGroup && jailbreak_ == AGResponseTypeBlock)
                {
                    continue; // 탈옥의심 차단 예외처리
                }
                procPatterns_[idx]->response_ = jailbreak_;
            }
            else if(procPatterns_[idx]->group_ == AGPatternGroupCheatingTool)
            {
                procPatterns_[idx]->response_ = cheating_;
            }
            else if(procPatterns_[idx]->group_ == AGPatternGroupDebugger)
            {
                procPatterns_[idx]->response_ = debugger_;
            }
            else if(procPatterns_[idx]->group_ == AGPatternGroupModification)
            {
                procPatterns_[idx]->response_ = modification_;
            }
            else if(procPatterns_[idx]->group_ == AGPatternGroupSimulator)
            {
                procPatterns_[idx]->response_ = simulator_;
            }
            else if(procPatterns_[idx]->group_ == AGPatternGroupHooking)
            {
                procPatterns_[idx]->response_ = hook_;
            }
            else if(procPatterns_[idx]->group_ == AGPatternGroupNetwork)
            {
                procPatterns_[idx]->response_ = network_;
            }
        }
    }
    AGLog(@"Set response - process patterns");
}

AG_PRIVATE_API void PatternManager::setResponseResourceIntegrityPattern() {
    unsigned long resourceIntegrityPatternSize = resourceIntegrityPattern_.size();
    if(resourceIntegrityPatternSize != 0) {
        for (int idx = 0; idx < resourceIntegrityPatternSize; idx++) {
            if(resourceIntegrityPattern_[idx]->group_ == AGPatternGroupModification) {
                resourceIntegrityPattern_[idx]->response_ = modification_;
            }
        }
    }
    AGLog(@"Set response - Resource Integrity patterns");
}


AG_PRIVATE_API void PatternManager::setResponseLocationSpoofPattern() {
    for(auto pattern : locationSpoofPatterns_) {
        pattern->response_ = locationSpoof_;
    }
    AGLog(@"Set response - location patterns");
}

AG_PRIVATE_API void PatternManager::setResponseScreenCapture() {
    for(auto pattern : screenCapturePatterns_) {
        pattern->response_ = screenCapture_;
    }
    AGLog(@"Set response - screen capture patterns");
}

AG_PRIVATE_API void PatternManager::setResponseScreenRecord() {
    for(auto pattern : screenRecordPatterns_) {
        pattern->response_ = screenRecord_;
    }
    AGLog(@"Set response - screen record patterns");
}

AG_PRIVATE_API void PatternManager::setResponseVPNDetection() {
    for(auto pattern : VPNDetectionPatterns_) {
        pattern->response_ = vpnDetection_;
    }
    AGLog(@"Set response - vpn detection patterns");
}

AG_PRIVATE_API void PatternManager::setResponseMacroTool() {
    for(auto pattern : macroToolPatterns_) {
        pattern->response_ = macroTool_;
    }
    AGLog(@"Set response - macro tool patterns");
}

// @author  : daejoon kim
// @param   : 정책 번호
// @return  : 리스폰 타입
// @brief   : 정책 번호에 따른 리스폰 타입을 전달
AG_PRIVATE_API AGResponseType PatternManager::getResponseType(int value) {
    AGResponseType result = AGResponseTypeOff;
    switch (value) {
        case 0:
            result = AGResponseTypeOff;
            break;
        case 1:
            result = AGResponseTypeDetect;
            break;
        case 2:
            result = AGResponseTypeBlock;
            break;
        case 3:
            result = AGResponseTypeConditional;
            break;
        case 4:
            result = AGResponseTypeIndividual;
            break;
        default:
            break;
    }
    return result;
}
// getter
AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeOfJailbreak()
{
    return jailbreak_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeOfCheating()
{
    return cheating_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeOfDebugger()
{
    return debugger_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeOfModification()
{
    return modification_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeOfSimulator()
{
    return simulator_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeOfHook()
{
    return hook_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeOfNetwork()
{
    return network_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeOfScreenCapture() {
    return screenCapture_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeScreenRecord() {
    return screenRecord_;
}

AG_PRIVATE_API AGResponseType PatternManager::getResponseTypeVPNDetection() {
    return vpnDetection_;
}

AG_PRIVATE_API
AGResponseType PatternManager::getResponseTypeOfLocationSpoof() {
    return locationSpoof_;
}

AG_PRIVATE_API
AGResponseType PatternManager::getResponseTypeMacroTool() {
    return macroTool_;
}



// setter
AG_PRIVATE_API void PatternManager::setResponseTypeOfJailbreak(AGResponseType type)
{
    jailbreak_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfCheating(AGResponseType type)
{
    cheating_  = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfDebugger(AGResponseType type)
{
    debugger_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfModification(AGResponseType type)
{
    modification_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfSimulator(AGResponseType type)
{
    simulator_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfHook(AGResponseType type)
{
    hook_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfNetwork(AGResponseType type)
{
    network_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfLocationSpoof(AGResponseType type) {
    locationSpoof_ = type;
}

AG_PRIVATE_API void PatternManager::offDebug()
{
    debugOn = false;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfScreenCapture(AGResponseType type) {
    screenCapture_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfScreenRecord(AGResponseType type) {
    screenRecord_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfVPNDetection(AGResponseType type) {
    vpnDetection_ = type;
}

AG_PRIVATE_API void PatternManager::setResponseTypeOfMacroTool(AGResponseType type) {
    macroTool_ = type;
}
