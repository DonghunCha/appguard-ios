//
//  PolicyManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 2019. 2. 27..
//  Copyright © 2019년 nhnent. All rights reserved.
//

#ifndef PolicyManager_hpp
#define PolicyManager_hpp

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <stdio.h>
#include <dispatch/dispatch.h>
#include <pthread.h>
#include <string>
#include "Log.h"
#include "Util.h"
#include "Pattern.h"
#include "ASString.h"
#include "Singleton.hpp"
#include "Decryptor.hpp"
#include "DetectManager.hpp"
#include "PatternManager.hpp"
#include "ScanDispatcher.hpp"
#include "AppGuardChecker.hpp"

#define MAX_DEFAULT_POLICY_DATA_LEN 0x1000 //4096
#define MAX_DEFAULT_POLICY_PAYLOAD_LEN (MAX_DEFAULT_POLICY_DATA_LEN - 8)

union default_policy {
    unsigned char rawData[MAX_DEFAULT_POLICY_DATA_LEN];
    struct {
        unsigned char signature[4];
        unsigned int payloadLength;
        unsigned char payload[1];
    };
};

class __attribute__((visibility("hidden"))) PolicyManager
{
public:
    void downloadPolicy(NSString* apiKey);
    bool setDefaultPolicy();
    std::string getPolicyFileUuid();
private:
    dispatch_queue_t appguardPolicyQueue;
    pthread_mutex_t downloadLock = PTHREAD_MUTEX_INITIALIZER;
    default_policy defaultPolicySignature =
        {"78ec0c5320bb81b15c8ec9f984b43b38039f09e1860f9b95a413ac7f6c574e2e63f0769c7b50ea869b1d0dfd0a26cbd167f9b9b218e1068fcd0bf1c853a8e369"};

    void download(NSString* apiKey);
    bool setPolicyWithFile(NSString* path);
    bool setPolicyWithJson(NSString* decJsonPolicy);
    bool validatePolicyJsonDict(NSDictionary *jsonDict);
    bool backupPolicyFile(NSString* srcPath);
    NSString* getPolicyURL(NSString* apiKey);
    NSString* getBackupPolicyPath();
    NSString* getDefaultPolicyFromSignature();
    std::string policyFileUuid_ = "unknown";
    bool defaultPolicy = false;
    bool downloadComplete = false;
};
#endif /* PolicyManager_hpp */
