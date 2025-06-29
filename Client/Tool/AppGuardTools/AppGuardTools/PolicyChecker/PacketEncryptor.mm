//
//  PacketEncryptor.cpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 6. 1..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "PacketEncryptor.hpp"

__attribute__((visibility("hidden"))) PacketEncryptor::PacketEncryptor()
{
    key_[0]  = 0x55EC8B55;
    key_[1]  = 0x6ADB57CE;
    key_[2]  = 0x7683D59C;
    key_[3]  = 0x31E449D9;
    key_[4]  = 0x4647C349;
    key_[5]  = 0x408114EA;
    key_[6]  = 0xBC6106DC;
    key_[7]  = 0xCAEC49CC;
    key_[8]  = 0x6AAF072B;
    key_[9]  = 0x12113B06;
    key_[10] = 0x6E78144E;
    key_[11] = 0xD3A45EC0;
    key_[12] = 0x50B53F10;
    key_[13] = 0x10A38139;
    key_[14] = 0x835A6BF0;
    key_[15] = 0x1992CD26;
    key_[16] = 0xFF33F8B3;
    key_[17] = 0x3A86ADC3;
    key_[18] = 0x501E5C74;
    key_[19] = 0xB46B2946;
    key_[20] = 0xCC321EFA;
    key_[21] = 0x8CA9289A;
    key_[22] = 0xD7ACE886;
    key_[23] = 0x43142264;
}

__attribute__((visibility("hidden"))) PacketEncryptor::~PacketEncryptor()
{
    
}

__attribute__((visibility("hidden"))) void PacketEncryptor::setKey(unsigned int* key)
{
    int i = 0;
    for (i = 0; i < 4; i++)
    {
        key_[i] = key[i];
    }
}

__attribute__((visibility("hidden"))) void PacketEncryptor::encryptBlock(unsigned int* v, unsigned int* key)
{
    int v0 = v[0], v1 = v[1], i;           /* set up */
    int delta = 0x9e3779b9;                         /* a key schedule constant */
    unsigned int sum = 0;
    unsigned int k0 = key[0], k1 = key[1], k2 = key[2], k3 = key[3]; /* cache key */
    for (i = 0; i < 32; i++)								 /* basic cycle start */
    {
        sum += delta;
        v0 += ((v1 << 4) + k0) ^ (v1 + (int)sum) ^ ((v1 >> 5) + k1);
        v1 += ((v0 << 4) + k2) ^ (v0 + (int)sum) ^ ((v0 >> 5) + k3);
    }														 /* end cycle */
    v[0] = v0;
    v[1] = v1;
}

__attribute__((visibility("hidden"))) void PacketEncryptor::decryptBlock(unsigned int* v, unsigned int* key)
{
    int v0 = v[0], v1 = v[1], i;     /* set up */
    int delta = 0x9e3779b9;                            /* a key schedule constant */
    unsigned int sum = 0xC6EF3720;
    unsigned int k0 = key[0], k1 = key[1], k2 = key[2], k3 = key[3];    /* cache key */
    for (i = 0; i<32; i++)
    {
        /* basic cycle start */
        v1 -= ((v0 << 4) + k2) ^ (v0 + (int)sum) ^ ((v0 >> 5) + k3);
        v0 -= ((v1 << 4) + k0) ^ (v1 + (int)sum) ^ ((v1 >> 5) + k1);
        sum -= delta;
    }															/* end cycle */
    v[0] = v0;
    v[1] = v1;
}

__attribute__((visibility("hidden"))) bool PacketEncryptor::encrypt(unsigned char* data, int dataSize, unsigned char** encryptedData, int* outSize)
{
    int count = 0;
    int encryptedSize = 0;
    int totalSize = 0;
    unsigned int seed = 0;
    int keyIndex = 0;
    unsigned char* encrypted = NULL;
    
    if (data == NULL || dataSize == 0)
        return false;
    
    if ((dataSize % 8) != 0)
        encryptedSize = dataSize + 8 - (dataSize % 8);
    else
        encryptedSize = dataSize;
    
    totalSize = encryptedSize + 4;
    
    *outSize = totalSize;
    encrypted = (unsigned char*)malloc(totalSize);
    if (encrypted == NULL)
        return false;
    
    memset(encrypted, 0, totalSize);
    memcpy(encrypted, data, dataSize);
    
    seed = (unsigned int)time(NULL);
    keyIndex = seed & 0xf;
    
    count = encryptedSize / 8;
    for (int i = 0; i < count; i++)
        encryptBlock((unsigned int*)(encrypted + (i * 8)), &key_[keyIndex]);
    
    memcpy((encrypted + encryptedSize), &seed, 4);
    *encryptedData = encrypted;
    
    return true;
}

__attribute__((visibility("hidden"))) bool PacketEncryptor::decrypt(unsigned char* data, int dataSize)
{
    int count = 0;
    int seed = 0;
    int keyIndex = 0;
    int encryptedSize = 0;
    
    if (data == NULL || dataSize == 0 || ((dataSize-4) % 8) != 0)
        return false;
    
    encryptedSize = dataSize - 4;
    memcpy(&seed, data + encryptedSize, 4);
    memset(data + encryptedSize, 0, 4);
    keyIndex = seed & 0xf;
    
    count = encryptedSize / 8;
    for (int i = 0; i < count; i++)
        decryptBlock((unsigned int*)(data + (i * 8)), &key_[keyIndex]);
    
    return true;
}

__attribute__((visibility("hidden"))) bool PacketEncryptor::encryptAndEncode(unsigned char* data, int size, char** encodedData)
{
    int encryptedSize = 0;
    unsigned char* encryptedData = NULL;
    char* encodedData_ = NULL;
    
    if (data == NULL)
        return false;
    
    // size + 1 = strlen(data) + 1(\0)
    if (encrypt(data, size, &encryptedData, &encryptedSize))
    {
        //LOGE("%s(%d) [%s]", __FUNCTION__, __LINE__, data);
        int len = Base64::encode(encryptedData, encryptedSize, NULL);
        if (len != 0)
        {
            encodedData_ = (char*)malloc(sizeof(char) * len);
            
            memset(encodedData_, 0, sizeof(char) * len);
            Base64::encode(encryptedData, encryptedSize, encodedData_);
            
            *encodedData = encodedData_;
        }
        
        free(encryptedData);
        encryptedData = NULL;
    }
    else
        return false;
    
    return true;
}

__attribute__((visibility("hidden"))) bool PacketEncryptor::decryptAndDecode(char* data, unsigned char** decodedData)
{
    int len = 0;
    int encryptedSize = 0;
    unsigned char* decodedData_ = NULL;
    
    if (data == NULL)
        return false;
    
//    len = (int)STInstance(CommonAPI)->cStrlen(data);
    len = (int)strlen(data);
    decodedData_ = (unsigned char*)malloc(sizeof(unsigned char) * len);
    memset(decodedData_, 0, sizeof(unsigned char) * len);
    encryptedSize = Base64::decode(data, decodedData_, len);
    
    if (decrypt(decodedData_, encryptedSize))
    {
        *decodedData = decodedData_;
    }
    else
        return false;
    
    return true;
}


__attribute__((visibility("hidden"))) NSString* PacketEncryptor::encryptAndEncode(NSString* str) {
    
    if([str length] == 0) {
        return nil;
    }
    
    char* encData = nullptr;
    if(!encryptAndEncode((unsigned char *)[str UTF8String], (int)strlen([str UTF8String]), &encData)) {
        return nil;
    }

    NSString* encStr = [NSString stringWithUTF8String:encData];
    free(encData);
    encData = nullptr;
    
    return encStr;
}

__attribute__((visibility("hidden"))) NSString* PacketEncryptor::decryptAndDecode(NSString* str) {
    
    if([str length] == 0) {
        return nil;
    }
    
    NSString* decStr = nil;
    PacketEncryptor packetEncryptor;
    
    char* decData = nullptr;
    if(!packetEncryptor.decryptAndDecode((char*)[str UTF8String], (unsigned char**)&decData)) {
        return nil;
    }
    
    decStr = [NSString stringWithUTF8String:decData];
    free(decData);
    decData = nullptr;
    
    return decStr;
}
