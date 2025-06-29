//
//  PacketEncryptor.h
//  appguard-ios
//
//  Created by NHNEnt on 2016. 6. 1..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef PacketEncryptor_h
#define PacketEncryptor_h

#pragma once

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Base64.hpp"
#import <Foundation/Foundation.h>
//#include "Log.h"
//#include "CommonAPI.hpp"
//#include "Singleton.hpp"

class __attribute__((visibility("hidden"))) PacketEncryptor
{
private:
    unsigned int key_[48];
    
    void encryptBlock(unsigned int* v, unsigned int* key);
    void decryptBlock(unsigned int* v, unsigned int* key);
    
public:
    PacketEncryptor();
    ~PacketEncryptor();
    
    void setKey(unsigned int* key);
    
    bool encrypt(unsigned char* data, int size, unsigned char** encryptedData, int* outSize);
    bool encryptAndEncode(unsigned char* data, int size, char** encodedData);
    bool decrypt(unsigned char* data, int size);
    bool decryptAndDecode(char* data, unsigned char** decryptedData);
    
    NSString* encryptAndEncode(NSString* str);
    NSString* decryptAndDecode(NSString* str);
};

#endif /* PacketEncryptor_h */
