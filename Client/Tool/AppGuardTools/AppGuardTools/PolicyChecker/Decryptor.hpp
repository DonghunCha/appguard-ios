//
//  Decryptor.hpp
//  AppGuard
//
//  Created by NHNEnt on 2019. 3. 28..
//  Copyright © 2019년 nhnent. All rights reserved.
//

#ifndef Decryptor_hpp
#define Decryptor_hpp


#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>
#include <stdio.h>

enum cryptorSize
{
    kBufSize = 512,
    kIVSize = 16,
};

class __attribute__((visibility("hidden"))) Decryptor
{
public:
    NSString* decryptData(const char* data, size_t dataSize);
private:
    unsigned char keyValue[kCCKeySizeAES256] = {0x4D, 0x3D, 0xAA, 0xD5, 0x86, 0x9D, 0x69, 0xC0, 0xAB, 0x6E, 0x5B, 0xF6, 0x5B, 0xB3, 0xF8, 0x94, 0x56, 0x32, 0xDD, 0x13, 0x2F, 0xB2, 0x79, 0xA8, 0x5F, 0x68, 0xF2, 0x3C, 0xF6, 0x42, 0x49, 0xF2};
    
};

#endif /* FileCryptor_hpp */
