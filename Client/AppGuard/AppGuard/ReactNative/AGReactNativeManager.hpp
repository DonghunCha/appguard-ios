//
//  AGReactNativeManager.hpp
//  AppGuard
//
//  Created by NHN on 3/4/24.
//

#ifndef AGReactNativeManager_hpp
#define AGReactNativeManager_hpp

#include <Foundation/Foundation.h>

__attribute__((visibility("hidden"))) size_t constexpr kEngineHeaderBundleNameBufferSize = 128;

typedef NS_OPTIONS(uint32_t, AGRactNativeJsbundleHeaderOptions) {
    AGRactNativeJsbundleHeaderOptionsCompressed = 1 << 0,
    AGRactNativeJsbundleHeaderOptionsEncrypted = 1 << 1,
};

typedef NS_ENUM(uint32_t, AGReactNativeBundleType) {
    AGReactNativeBundleTypeHermesBCBundle = 0,
    AGReactNativeBundleTypeStringBundle,
    AGReactNativeBundleTypeRamBundle
};



struct __attribute__((packed)) __attribute__((visibility("hidden"))) AGReactNativeJsbundleHeader{
    uint64_t agMagic;
    unsigned char originalHash[32]; //binary bytes of hash.
    uint64_t originalPayloadLength;
    uint64_t encryptedPayloadLength;
    uint64_t compressedPayloadLength;
    AGRactNativeJsbundleHeaderOptions options;
    uint64_t reserved;
};

struct __attribute__((packed)) __attribute__((visibility("hidden"))) AGReactNativeEngineHeader{
    uint64_t agMagic;
    char xorJSBundleName[kEngineHeaderBundleNameBufferSize];
    AGReactNativeBundleType bundleType;
    uint32_t integrityCheckOnly;
    AGReactNativeJsbundleHeader agHeader;
};


union __attribute__((packed)) __attribute__((visibility("hidden"))) AGReactNativeSignature {
    unsigned char signature[260];
    AGReactNativeEngineHeader reactNativeEngineHeader;
};

class __attribute__((visibility("hidden"))) AGReactNativeManager {
public:
    AGReactNativeManager();
    bool Initialize();
    void SetIntegrityCheck(bool isValid);
    bool GetIntegrityCheck();
    NSString* GetEngineHeaderInfoString();
    static AGReactNativeSignature reactNativeSignatue_;
private:
    bool integrityIsValid_;
};


#endif /* AGReactNativeManager_hpp */
