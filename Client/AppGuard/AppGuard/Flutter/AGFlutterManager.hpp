//
//  AGFlutterManager.hpp
//  AppGuard
//
//  Created by NHN on 3/19/24.
//

#ifndef AGFlutterManager_hpp
#define AGFlutterManager_hpp

#include <Foundation/Foundation.h>
#include <CommonCrypto/CommonCrypto.h>

__attribute__((visibility("hidden"))) uint64_t constexpr kAGFlutterProtectionMagic = 0x251203E103BF3E31;
__attribute__((visibility("hidden"))) constexpr size_t kMinimumSha256HashStringBufferLength = CC_SHA256_DIGEST_LENGTH * 2 + 4; //68

union __attribute__((packed)) __attribute__((visibility("hidden"))) AGFlutterSignature {
    unsigned char signature[256];
    struct __attribute__((packed)) {
        uint64_t magic;
        char flutterFrameworkTextSectionHash[kMinimumSha256HashStringBufferLength];
        char appFrameworkConstSectionHash[kMinimumSha256HashStringBufferLength];
        char appFrameworkTextSectionHash[kMinimumSha256HashStringBufferLength];
    };
};

class __attribute__((visibility("hidden"))) AGFlutterManager {
public:
    AGFlutterManager();
    ~AGFlutterManager();
    bool CheckAppFrameworkIntegrity();
    bool CheckFlutterFrameworkIntegrity();
    static bool IsFlutterProtection();
    static AGFlutterSignature flutterSignature_;

};

#endif /* AGFlutterManager_hpp */
