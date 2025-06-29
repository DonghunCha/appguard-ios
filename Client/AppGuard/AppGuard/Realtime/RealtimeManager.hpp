//
//  RealtimeManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 22/06/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef RealtimeManager_hpp
#define RealtimeManager_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include "Log.h"
#include "Util.h"
#include "ASString.h"
#include "CommonAPI.hpp"
#include "Singleton.hpp"
#include "EncodedDatum.h"
#include "DetectManager.hpp"
#include "PacketEncryptor.hpp"
#include "EnvironmentManager.hpp"
#include "Pattern.h"

class __attribute__((visibility("hidden"))) RealtimeManager
{
public:
    void startCheckBlackListPolicy();
    bool isBlockConditionalPolicy(AGPatternGroup patterngroup);
private:
    bool checkRealTimePolicy(NSString* appKey, NSString* userId, NSString* deviceId, AGPatternGroup patterngroup);
    void setUserSeq(int seq);
    static const int kRuleGroupSeq[];
    dispatch_queue_t realTimeQueue;
    pthread_mutex_t realTimeLock = PTHREAD_MUTEX_INITIALIZER;
    
    int userSeq_ = 0;
    
};

#endif /* RealtimeManager_hpp */
