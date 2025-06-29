//
//  AGReactNativeManager.mm
//  AppGuard
//
//  Created by NHN on 3/4/24.
//

#include "AGReactNativeManager.hpp"

#include <objc/runtime.h>
#include <CommonCrypto/CommonCrypto.h>

#include <string>
#include <functional>

#include "Util.h"
#include "EnvironmentManager.hpp"



__attribute__((visibility("hidden"))) uint64_t constexpr kAGReactNativeHeaderMagic = 0x2F1803C103BC2FC5;

// react native sdk 참조 (JSBundleType.h)
__attribute__((visibility("hidden"))) static uint32_t constexpr kRAMBundleMagicNumber __unused = 0xFB0BD1E5;//for Ram Bundle
__attribute__((visibility("hidden"))) static uint64_t constexpr kHermesBCBundleMagicNumber = 0x1F1903C103BC1FC6; // for Hermes Bundle

__attribute__((visibility("hidden"))) static size_t constexpr kSizeOfFacebookReactBundleHeader = 12;

typedef NSData* (*IMPNSDataDataWithContentsOfFile)(id, SEL, NSString*, NSDataReadingOptions, NSError**);
//FOLLY_PACK_PUSH
//
//struct FOLLY_PACK_ATTR Magic32 {
//  uint32_t value;
//  uint32_t reserved_;
//};
//
//struct FOLLY_PACK_ATTR BundleHeader {
//  BundleHeader() {
//    std::memset(this, 0, sizeof(BundleHeader));
//  }
//
//  union {
//    Magic32 magic32;
//    uint64_t magic64;
//  };
//  uint32_t version;
//};
//FOLLY_PACK_POP

__attribute__((visibility("hidden"))) static IMP ImpOriginalNSDataDataWithContentsOfFile = nil;

__attribute__((visibility("hidden"))) static unsigned char constexpr kBundleNameXORKey = 24;


__attribute__((visibility("hidden"))) AGReactNativeSignature AGReactNativeManager::reactNativeSignatue_;

__attribute__((visibility("hidden")))
static NSString* GetJSBundleFromEngineHeader(AGReactNativeEngineHeader& engineHeader);

__attribute__((visibility("hidden")))
static NSData* GetDecryptPayload(unsigned char* encData, size_t encDataLength, size_t originalLength, unsigned char* originalPayloadHashDigest) {
    NSMutableData* tempData = [NSMutableData dataWithLength:encDataLength];
    unsigned char* tempBuf = ( unsigned char* )[tempData bytes];

    // key = sha256( appkey string + original payload sha256 hash string ).digest()
    size_t numBytesDecrypted = 0;
    NSString* apiKey = [NSString stringWithUTF8String: STInstance(EnvironmentManager)->getApiKey().c_str()];
    NSMutableString *hashString = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (NSUInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hashString appendFormat:@"%02x", originalPayloadHashDigest[i]];
    }
    NSString* key = [apiKey stringByAppendingString:hashString];
    NSData* encryptKey = Util::sha256HashDigest(key);
    
    //복호화를 해본다.
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES, kCCOptionECBMode,
            encryptKey.bytes, encryptKey.length,
            NULL,
            encData, encDataLength,
            tempBuf, encDataLength,
            &numBytesDecrypted);
    
    if (cryptStatus != kCCSuccess) {
        AGLog(@"Decryption failed");
        return nil;
    }
    
    AGLog(@"Decrypted Bytes : %lu", numBytesDecrypted);
    
    //패딩때문에 길이를 원본데이터 만큼 잘라버린다.
    return [NSData dataWithBytes:tempBuf length:originalLength];
}


__attribute__((visibility("hidden")))
AGReactNativeManager::AGReactNativeManager()
:integrityIsValid_(true)
{
    AGReactNativeManager::reactNativeSignatue_ = {"7c29dcc88f641f63fc2aaa55f8298615cb701696eff2b468e4888f0e454be898"};
}

__attribute__((visibility("hidden")))
static NSData* SwizzledNSDataDataWithContentsOfFile(id self, SEL _cmd, NSString * path ,NSDataReadingOptions readOptionsMask, NSError ** errorPtr) {
    

    //원본 함수 호출
    IMPNSDataDataWithContentsOfFile originalNSDataDataWithContentsOfFile = (IMPNSDataDataWithContentsOfFile)ImpOriginalNSDataDataWithContentsOfFile;
    NSData* data = originalNSDataDataWithContentsOfFile(self, _cmd, path, readOptionsMask, errorPtr);
    
    if(data == nil) {
        AGLog(@"data is nil %@", path);
        return data;
    }
    
    //RTCJavaScriptLoader에서 NSData dataWithContentsOfFile 호출할 때 플래그
    if(readOptionsMask != NSDataReadingMappedIfSafe) {
        AGLog(@"readOptionsMask is not NSDataReadingMappedIfSafe");
        return data;
    }
    
    if([data length] == 0) {
        AGLog(@"data is empty(length == 0)");
        return data;
    }
    BOOL isExpoBundle = NO;
    NSString* expoBundlePath = [NSString stringWithFormat:@"%@", NS_SECURE_STRING(string_expo_intenal_path)];
    if([path containsString:expoBundlePath]) {
        AGLog(@"path is expo internal bundle.. %@", path);
        isExpoBundle = YES;
    }
    
    if(isExpoBundle == NO)
    {
        NSString* BundleName = GetJSBundleFromEngineHeader(AGReactNativeManager::reactNativeSignatue_.reactNativeEngineHeader);
        AGLog(@"SwizzledNSDataDataWithContentsOfFile path %@ bundlename %@ ", path, BundleName);
        if([BundleName length] != 0) {
            if(![path containsString:BundleName]) {
                AGLog(@"path is not protected jsbunle path %@", path);
                return data;
            }
            NSString* codePushSubPath = [NSString stringWithFormat:@"/%@/%@", NS_SECURE_STRING(string_code_push), BundleName];
            if([path containsString:codePushSubPath]) {
                AGLog(@"path is Codepush bundle.. Bypass %@", path);
                return data;
            }
        }
    }
    
    bool isAppGuardProtected = false;
    size_t agHeaderOffest = 0; // 앱가드 헤더 오프셋
    
    // 원본 버퍼 얻기
    unsigned char* rawBuffer = (unsigned char*)[data bytes];
    
    //check Hermes header
    if(memcmp((uint64_t*)rawBuffer, &kHermesBCBundleMagicNumber, sizeof(uint64_t)) == 0) {
        AGLog(@"Hermes BC Bundle Magic Number is found.");
        agHeaderOffest = kSizeOfFacebookReactBundleHeader;
    } else if (memcmp((uint32_t*)rawBuffer, &kRAMBundleMagicNumber, sizeof(uint32_t)) == 0) {
        AGLog(@"RAM Bundle Magic Number is found.????");
        return data;
    } else {
        AGLog(@"Hermes BC Bundle Magic Number is not found. maybe string bundle?");
        agHeaderOffest = 0;
    }
    
    //check AppGuard React Native Header
    AGReactNativeJsbundleHeader* agHeader = (AGReactNativeJsbundleHeader*)&rawBuffer[agHeaderOffest];
    if(memcmp(&AGReactNativeManager::reactNativeSignatue_.reactNativeEngineHeader.agHeader, agHeader, sizeof(AGReactNativeJsbundleHeader)) != 0) {
        AGLog(@"Engin Header != Bundle File Header ");
        if(isExpoBundle) {
            AGLog(@"Engin Header != Bundle File Header but it is expo updated bundle.");
            return data;
        }else {
            return nil;
        }
    }
    
    agHeader = &AGReactNativeManager::reactNativeSignatue_.reactNativeEngineHeader.agHeader;
    
    if(agHeader->agMagic == kAGReactNativeHeaderMagic) {
        AGLog(@"AppGuard React Native Bundle Magic Number is found.");
        isAppGuardProtected = true;
    }
    
    if(isAppGuardProtected == false) {
        AGLog(@"AppGuard React Native Bundle Magic Number is not found.");
        return data;
    }
    
    //복호화
    unsigned char* payload = (unsigned char*)&rawBuffer[agHeaderOffest + sizeof(AGReactNativeJsbundleHeader)];
    NSData* decryptedPayload = nil;
    
    if(agHeader->options & AGRactNativeJsbundleHeaderOptionsEncrypted) {
        AGLog(@"AppGuard jsbundle is encrypted. Attempt decryption.");
        decryptedPayload = GetDecryptPayload(payload, agHeader->encryptedPayloadLength, agHeader->originalPayloadLength, agHeader->originalHash);
    } else {

        data = [NSData dataWithBytes:payload length:agHeader->originalPayloadLength];
        AGLog(@"AppGuard jsbundle is not encrypted. data length=%lu", (unsigned long)[data length]);
        return data;
    }
    
    if(decryptedPayload == nil) {
        AGLog(@"decrypt is fail.");
        return nil;
    }
    
    // 해시검증
    NSData* hashDigest = Util::sha256HashDigest(decryptedPayload);
    if(![hashDigest isEqualToData:[NSData dataWithBytes: agHeader->originalHash length:32]]) {
        AGLog(@"The hash of the decrypted data does not match.");
        STInstance(AGReactNativeManager)->SetIntegrityCheck(false);
        return nil;
    } else {
        AGLog(@"The hash of the decrypted data is correct!!");
    }
    STInstance(AGReactNativeManager)->SetIntegrityCheck(true);
    AGLog(@"JSBundle loaded successfully!");
    
    return (NSData*)decryptedPayload;
}

__attribute__((visibility("hidden")))
static NSString* GetJSBundleFromEngineHeader(AGReactNativeEngineHeader& engineHeader) {
    NSMutableString* bundleName = [NSMutableString stringWithCapacity:kEngineHeaderBundleNameBufferSize];
    for(int i = 0 ; i < kEngineHeaderBundleNameBufferSize ; i++ ) {
        if(engineHeader.xorJSBundleName[i] == 0x00) { // 널 문자까지만 복호화
            break;
        }
        [bundleName appendFormat:@"%c", engineHeader.xorJSBundleName[i] ^ kBundleNameXORKey];
    }
    AGLog(@"xor bundle name: %@", bundleName);
    return bundleName;
}

__attribute__((visibility("hidden")))
bool AGReactNativeManager::Initialize() {
    
    
    if(reactNativeSignatue_.reactNativeEngineHeader.agMagic != kAGReactNativeHeaderMagic) {
        AGLog(@"This App is not protected for React Native.");
        return true;
    }
    
    if(reactNativeSignatue_.reactNativeEngineHeader.integrityCheckOnly == 1) {
        NSString* BundleName = GetJSBundleFromEngineHeader(reactNativeSignatue_.reactNativeEngineHeader);
        if([BundleName length] != 0 ) {
            NSString* bundlePath = [[NSBundle mainBundle] pathForResource:[BundleName stringByDeletingPathExtension] ofType:[BundleName pathExtension]];
            NSData* bundleData = [NSData dataWithContentsOfFile:bundlePath options:NSDataReadingMappedIfSafe error:nil];
            if(bundleData == nil) {
                AGLog(@"Integrity CheckOnly bundle is not found..(%@)", bundlePath);
                return true;
            }
            
            NSData* hashDigestData = Util::sha256HashDigest(bundleData);
            if(![hashDigestData isEqualToData:[NSData dataWithBytes: reactNativeSignatue_.reactNativeEngineHeader.agHeader.originalHash length:32]]){
                AGLog(@"The hash of the Integrity CheckOnly bundle data does not match.");
                STInstance(AGReactNativeManager)->SetIntegrityCheck(false);
            } else {
                AGLog(@"The hash of the Integrity CheckOnly bundle data does is correct!!");
                STInstance(AGReactNativeManager)->SetIntegrityCheck(true);
            }
        }
        return true;
    }
    
    //Swizzling method
    Class NSDataClass = NSData.class;
    Method dataWithContentsOfFileMethod = nil;
    if([NSDataClass respondsToSelector:@selector(dataWithContentsOfFile: options: error:)]) {
        dataWithContentsOfFileMethod = class_getClassMethod(NSDataClass, @selector(dataWithContentsOfFile: options: error:));
        ImpOriginalNSDataDataWithContentsOfFile = method_setImplementation(dataWithContentsOfFileMethod,(IMP)SwizzledNSDataDataWithContentsOfFile);
        AGLog(@"Swizzling NSData dataWithContentsOfFile");
        return true;
    } else {
        AGLog(@"Fail to Swizzling NSData dataWithContentsOfFile");
    }
    return false;
}

__attribute__((visibility("hidden")))
void AGReactNativeManager::SetIntegrityCheck(bool isValid) {
    integrityIsValid_ = isValid;
}

__attribute__((visibility("hidden")))
bool AGReactNativeManager::GetIntegrityCheck() {
    return integrityIsValid_;
}

__attribute__((visibility("hidden")))
NSString* AGReactNativeManager::GetEngineHeaderInfoString() {
    if(reactNativeSignatue_.reactNativeEngineHeader.agMagic != kAGReactNativeHeaderMagic) {
        return @"";
    }
    
    NSString* info = [NSString stringWithFormat:@"%d, %d, %@",
                      reactNativeSignatue_.reactNativeEngineHeader.bundleType,
                      reactNativeSignatue_.reactNativeEngineHeader.integrityCheckOnly,
                      GetJSBundleFromEngineHeader(reactNativeSignatue_.reactNativeEngineHeader)];
    
    AGLog(@"%@", info);
    return info;
}
