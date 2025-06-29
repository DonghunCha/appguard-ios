//
//  Decryptor.cpp
//  AppGuard
//
//  Created by NHNEnt on 2019. 3. 28..
//  Copyright © 2019년 nhnent. All rights reserved.
//

#include "Decryptor.hpp"

// @author  : daejoon kim
// @param   : 타겟 파일
// @return  : 복호화 내용
// @brief   : 암호화된 파일의 AES256 복호화 수행
__attribute__((visibility("hidden"))) NSString* Decryptor::decryptFile(NSString* path)
{
    AGLog(@"Decrypt target file - [%@]", path);
    @try
    {
        NSString * result = nil;
        const char* policyPath = NS2CString(path); // policy.ag
        FILE* fp = fopen(policyPath, "rb");
        if(fp)
        {
            char readBuf[kBufSize] = {0,};
            // 사이즈 가져오기
            size_t policySize = Util::getFileSizeByStat(policyPath);
            fread(readBuf, sizeof(Byte), policySize, fp);
            fclose(fp);
            result = decryptData(readBuf, policySize);
        }
        return result;
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
        return nil;
    }
}


// @author  : daejoon kim
// @param   : 타겟 데이터
// @return  : 복호화 내용
// @brief   : 암호화된 파일의 AES256 복호화 수행
__attribute__((visibility("hidden"))) NSString* Decryptor::decryptData(const char* data, size_t dataSize)
{
    AGLog(@"Decrypt data Size: [%zu]", dataSize);
    @try
    {
        NSString * result = nil;
        char ivBuf[kIVSize] = {0,};
        char encBuf[kBufSize] = {0,};

        if(dataSize != 0)
        {
            size_t encSize = dataSize - kIVSize; // 앞에 16바이트는 iv 값이므로 암호화된 데이터는 전체 크기에서 16바이트를 빼야함
            memcpy(ivBuf, data, kIVSize);
            memcpy(encBuf, data + kIVSize, encSize);
            
            size_t decSize = dataSize - kIVSize + kCCBlockSizeAES128;
            char* decBuf = (char*)malloc(decSize * sizeof(char));
            memset(decBuf, 0, decSize);
            
            size_t numBytesDecrypted = 0;
            
            // 복호화
            CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyValue, kCCKeySizeAES256, ivBuf, encBuf, encSize, decBuf, decSize, &numBytesDecrypted);
            if(cryptStatus == kCCSuccess)
            {
                result = [NSString stringWithCString:decBuf encoding:NSASCIIStringEncoding];
            }
            
            memset(ivBuf, 0, kIVSize);
            memset(encBuf, 0, encSize);
            memset(decBuf, 0, decSize);
            
            free(decBuf);
            decBuf = nullptr;
        }
        return result;
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
        return nil;
    }
}

