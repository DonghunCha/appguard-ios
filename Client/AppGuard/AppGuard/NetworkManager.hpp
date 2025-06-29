//
//  NetworkManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 05/02/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef NetworkManager_hpp
#define NetworkManager_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include "Log.h"
#include "Util.h"
#include "ASString.h"
#include "EncodedDatum.h"

class __attribute__((visibility("hidden"))) NetworkManager
{
public:
    NSString* getURL();
    NSData* getPublicKey();
    void setPinningValue(char* value);
    char* getPinningValue();
private:
    char* pinningValue_ = nullptr;
};

#endif /* NetworkManager_hpp */
