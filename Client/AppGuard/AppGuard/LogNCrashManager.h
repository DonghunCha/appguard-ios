//
//  LogNCrashManager.h
//  AppGuard
//
//  Created by NHNENT on 2017. 6. 14..
//  Copyright © 2017년 NHNENT. All rights reserved.
//

#ifndef LogNCrashManager_h
#define LogNCrashManager_h

#import <Foundation/Foundation.h>
#include "Log.h"
#include "Util.h"
#include "LogNCrash.h"
#include "Singleton.hpp"
#include "PacketEncryptor.hpp"
#include "EnvironmentManager.hpp"

@interface LogNCrashManager : NSObject

+ (void) init:(NSString*)server ofAppKey:(NSString*)appKey withVersion:(NSString*)appVersion forUserId:(NSString*)userId;
+ (void) setUserId:(NSString *)userId;
+ (void) sendLog:(NSString*)body;
+ (void) setDefaultFields;
+ (void) setCustomField:(NSString*)value forKey:(NSString*)key;
+ (void) removeAllCustomFields;

@end

#endif /* LogNCrashManager_h */
