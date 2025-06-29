//
//  EncryptionAPI.hpp
//  AppGuard
//
//  Created by NHNEnt on 11/07/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#ifndef EncryptionAPI_hpp
#define EncryptionAPI_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include "Util.h"
#include "Pattern.h"
#include "ASString.h"
#include "Base64.hpp"
#include "Singleton.hpp"
#include "CommonAPI.hpp"
#include "PatternManager.hpp"
#include "AppGuardChecker.hpp"
#include "SecurityEventHandler.h"

#define PUBLIC_KEY_SIZE     272
#define AUTH_ENC_VERSION    1701

class __attribute__((visibility("hidden"))) EncryptionAPI
{
public:
    EncryptionAPI();
    ~EncryptionAPI();
    
    void setEncFlagA();
    void setEncFlagB();
    void setEncFlagC();
    void setEncFlagD();

private:
    dispatch_queue_t appguardEncryptionQueue;
    int flagA_ = 0;
    int flagB_ = 0;
    int flagC_ = 0;
    int flagD_ = 0;
    bool firstRSALoad_ = true;
    
    static const unsigned char rsaPublicKey_[162];
    
    int checkExcuteAppGuard();
};
#endif /* EncryptionAPI_hpp */
