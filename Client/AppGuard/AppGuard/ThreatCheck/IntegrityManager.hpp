//
//  IntegrityManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 16/04/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#ifndef IntegrityManager_hpp
#define IntegrityManager_hpp

#include <CommonCrypto/CommonCrypto.h>
#include <stdio.h>
#include <dlfcn.h>
#include <sys/mman.h>
#include <mach-o/fat.h>
#include <mach-o/dyld.h>
#include <mach/machine.h>
#include "Log.h"
#include "Util.h"
#include "ASString.h"
#include "Singleton.hpp"
#include "CommonAPI.hpp"
#include "CodeSigning.h"
#include "EncodedDatum.h"

enum iOSFormat
{
    kNone = 0,
    kFAT = 1,
    kMachO = 2,
};

class __attribute__((visibility("hidden"))) IntegrityManager
{
public:
    IntegrityManager();
    ~IntegrityManager();
    bool checkDylibInjection();
    bool checkUnityFramework();
    bool checkTextSectionHashByProtector();
    bool checkTextSectionHash();
    uint8_t* checkSigner();
    bool checkCodeSignatureHash();
    bool checkCryptId();
    bool checkCryptIdOfFAT(void* addr);
    bool checkCryptIdOfMachO(void* addr);
    const char* getTextSectionHash();
    
private:
    static const size_t kTextSectionHashMaxLen = CC_SHA1_DIGEST_LENGTH * 2 + 1;
    char firstMemoryHash_[kTextSectionHashMaxLen];
    void makeTextSegmentSectionSha256BySectionName(char * result, int imageIndex, const char* sectionName);
    bool checkOrignalUnityHash(const char* textSectionHashBySDK, const char* il2cppSectionHashBySDK);
    size_t getLoadCommandOffset(uint32_t magic);
    iOSFormat checkFileFormat(void * addr);
    bool getTextSectionHash(void* addr, char* const hashBuf, size_t buflen);
    bool checkCodeHash(void* addr);
    bool checkCodeHashOfFAT(void * addr);
    char compareCodeHash(const void* data, size_t length, size_t slot, const CS_CodeDirectory* codeDirectory);
    int getTargetImageIndex();
    
    bool firstExecute = true;
    char textSectionHash[kTextSectionHashMaxLen];
    uint8_t binarySigner[256] = { 0, };

};

#endif /* IntegrityManager_hpp */
