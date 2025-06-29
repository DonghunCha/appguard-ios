//
//  AppGuardAPIWrapper.hpp
//  AppGuard
//
//  Created by NHNEnt on 25/02/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef AppGuardAPIWrapper_hpp
#define AppGuardAPIWrapper_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include "Log.h"
#include "Util.h"
#include "Diresu.h"
#include "ASString.h"
#include "LogNCrash.h"
#include "Singleton.hpp"
#include "CommonAPI.hpp"
#include "EncodedDatum.h"
#include "EncryptionAPI.hpp"
#include "PolicyManager.hpp"
#include "PatternManager.hpp"
#include "ResponseManager.hpp"

class __attribute__((visibility("hidden"))) AppGuardAPIWrapper
{
public:
    static int s(NSString* apiKey, NSString* userName, NSString* appName, NSString* version);
    static int o(IMP pointer, bool useAlert);
    static int v(void* pointer, bool useAlert);
    static int w(bool useAlert);
    static int n(NSString* username);
    static void e(NSString* data);
    static void k();
    static void t();
    static void z();
    static void free();
protected:
    static NSString* unknown_;
};
#endif /* AppGuardAPIWrapper_hpp */
