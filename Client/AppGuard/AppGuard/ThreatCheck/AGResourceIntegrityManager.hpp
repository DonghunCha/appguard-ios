//
//  AGResourceIntegrityManager.hpp
//  AppGuard
//
//  Created by NHN on 2023/05/02.
//

#ifndef AGResourceIntegrityManager_hpp
#define AGResourceIntegrityManager_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>

#define AG_SHA256_SIGNATURE_LEN 64
#define AG_UPDATED_RESOURCE_SIGNATRUE_LEN AG_SHA256_SIGNATURE_LEN
#define AG_MAX_RESOURCE_SIGNATURE_DATA_LEN 512

typedef NS_ENUM(int, AGResourceType) {
    AGResourceTypeInfoPlist = 4837,
};

class  __attribute__((visibility("hidden"))) AGResourceIntegrityManager {
public:
    AGResourceIntegrityManager();
    ~AGResourceIntegrityManager();

    // 8바이트 alignment를 맞춰줘야함.
    union AGResourceIntegritySignature {
        unsigned char rawData[AG_MAX_RESOURCE_SIGNATURE_DATA_LEN];
        struct {
            char updatedSignature[AG_UPDATED_RESOURCE_SIGNATRUE_LEN+8];
            char sha256Hash[AG_SHA256_SIGNATURE_LEN+8];
            unsigned long long resouceSize;  //reserved
            AGResourceType type;
            unsigned char dummy[1]; //더미
        };
    };

    
    bool checkInfoPlist(NSString** infoPlistHashOriginalString);
    
private:
    AGResourceIntegritySignature infoPlistSignature = {"08997197cc96b3a7487d5ecfbf90ad30e9778691a4320aa4592f9331e85fa3313f8871ad22d446191ee3beb5c9650c9b3efb820452922d65b214aedf87000b79"};
    NSString* getInfoPlistValueHashOriginalString(NSString* plistPath);
    bool isValidSignature(const AGResourceIntegritySignature& signature);
    bool isFileExists(NSString* filePath);
};

#endif /* ResourceIntegrityManager_hpp */
