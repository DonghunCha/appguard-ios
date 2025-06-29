//
//  Pattern.h
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef Pattern_h
#define Pattern_h

#include <string>

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, AGPatternGroup) {
    AGPatternGroupRegisterCallback = -6,
    AGPatternGroupBehavior = -11,
    AGPatternGroupNone = 0,
    AGPatternGroupCheatingTool = 1,
    AGPatternGroupSimulator = 2,
    AGPatternGroupModification = 4,
    AGPatternGroupDebugger = 5,
    AGPatternGroupNetwork = 12,
    AGPatternGroupJailbreak = 10,
    AGPatternGroupHooking = 11,
    AGPatternGroupMacroTool = 17,
    AGPatternGroupLocationSpoofing = 18,
    AGPatternGroupScreenCapture = 20,
    AGPatternGroupScreenRecord = 21,
    AGPatternGroupVPN = 22,
    AGPatternGroupBlackList = 90,
};

typedef NS_ENUM(int, AGPatternName) {
    AGPatternNameFreeUser = -26,
    AGPatternNameIAPTweak = -25,
    AGPatternNameBehavior = -11,
    AGPatternNameDefaultCallback = -17,
    
    AGPatternNameNone = 0,
    
    AGPatternNameAppguardModification = 3,
    AGPatternNameGameGuadian = 10,
    AGPatternNameGameHacker = 13,
    AGPatternNameNativeDebugger = 31,
    AGPatternNameDebuggerGroup = 33,
    AGPatternNameGamePlayer = 35,
    AGPatternNameFlex = 36,
    AGPatternNameMemSearch = 37,
    AGPatternNameCodeModification = 38,
    AGPatternNameJailbreakGroup = 39,
    AGPatternNameJailbreakActive = 47,
    AGPatternNameGameGem = 62,
    
    AGPatternNameIPAModification = 70,
    AGPatternNameIPADecryption = 71,
    AGPatternNameTweak = 72,
    
    AGPatternNameBlackList = 90,
    AGPatternNameJailedCheat = 95,
    AGPatternNameSimulator = 96,
    AGPatternNameCAPIHook = 97,
    AGPatternNameObjcAPIHook = 98,
    AGPatternNameUserFuntionHook = 99,
    AGPatternNameSSLPinning = 100,
    AGPatternNameAppGuardHook = 101,
    AGPatternNameInfoPlistModification = 124,
    AGPatternNameIPADump = 126,
    AGPatternNameMockLocation = 132,
    AGPatternNameScreenCapture = 145,
    AGPatternNameScreenRecord = 146,
    AGPatternNameVPNConnection = 147,
    AGPatternNameSwitchControl = 148,
};

typedef NS_ENUM(int, AGResponseType) {
    AGResponseTypeOff = 0,
    AGResponseTypeDetect = 1,
    AGResponseTypeBlock = 2,
    AGResponseTypeConditional = 3,
    AGResponseTypeIndividual = 4,
}; //0 : off / 1 : detect / 2 : block / 3 : cond / 4 : individual
// 변경시 PatternManager::getResponseType 변경필요



class __attribute__((visibility("hidden"))) Pattern
{
public:
    int index_;
    AGPatternGroup group_;
    AGPatternName name_;
    AGResponseType response_;
    
    Pattern(){};
    Pattern(int index, AGPatternGroup group, AGPatternName name, AGResponseType response)
    {
        index_ = index;
        group_ = group;
        name_ = name;
        response_ = response;
    };
};

#endif /* Pattern_h */
