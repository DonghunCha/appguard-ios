//
//  SignerCheck.h
//  AppGuard
//
//  Created by NHN on 2020/11/26.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef SignerCheck_h
#define SignerCheck_h

#include "CodeSigning.h"
#define AG_INLINE static __inline__ __attribute__((always_inline))


AG_INLINE int CheckRequirements(CS_SuperBlob *pSBlob, CS_BlobIndex *pBlob, uint8_t * orgSigner, uint8_t * binarySigner)
{
    
    uint32_t offset = OSSwapInt32(pBlob->offset);
    CS_SuperBlob *pRequirements = (CS_SuperBlob*)((uint8_t*)pSBlob + offset);
    
    // -- CSMAGIC_REQUIREMENTS
    if (OSSwapInt32(pRequirements->magic) != CSMAGIC_REQUIREMENTS)
    {
        AGLog(@"CSMAGIC_REQUIREMENTS Not Found");
        return -1;
    }
    uint32_t reqs_count = OSSwapInt32(pRequirements->count);
    if (reqs_count == 0)
    {
        AGLog(@"Requirements->count Not Found");
        return -1;
    }
    CS_BlobIndex *pRequirement = (CS_BlobIndex*)((uint8_t*)pRequirements + sizeof(CS_SuperBlob));
    for (uint32_t i=0; i<reqs_count; i++)
    {
        // -- CSSLOT_RESOURCEDIR
        if (OSSwapInt32(pRequirement[i].type) != CSSLOT_RESOURCEDIR)
        {
            AGLog(@"OSSwapInt32(pRequirement[i].type) != CSSLOT_RESOURCEDIR");
            continue;
        }
        uint32_t reqdir_off = OSSwapInt32(pRequirement[i].offset);
        CS_SuperBlob *pResDir = (CS_SuperBlob*)((uint8_t*)pRequirements + reqdir_off);
        
        // -- CSMAGIC_REQUIREMENT
        if (OSSwapInt32(pResDir->magic) != CSMAGIC_REQUIREMENT)
        {
            AGLog(@"OSSwapInt32(pResDir->magic) != CSMAGIC_REQUIREMENT");
            continue;
        }
        uint32_t resdir_length = OSSwapInt32(pResDir->length);
        for (uint32_t op_off = reqdir_off + sizeof(CS_SuperBlob);
                op_off < reqdir_off + resdir_length - sizeof(CS_SuperBlob);
                op_off += sizeof(uint32_t))
        {
            uint32_t op = *((uint32_t*)((uint8_t*)pRequirements + op_off));
            op = OSSwapInt32(op);
            if (op != 11)  // opCertField
                continue;
            
            uint32_t len1 = *((uint32_t*)((uint8_t*)pRequirements + op_off + 8));
            len1 = OSSwapInt32(len1);
            len1 = len1 + len1 % 4;
            if ((len1 == 0) || (op_off+12+len1 >= reqdir_off+resdir_length))
                continue;
            
            uint32_t match = *((uint32_t*)((uint8_t*)pRequirements + op_off + len1 + 12));
            match = OSSwapInt32(match);
            if (match != 1)  // matchEqual
                continue;
            
            uint32_t len2 = *((uint32_t*)((uint8_t*)pRequirements + op_off + len1 + 16));
            len2 = OSSwapInt32(len2);
            if ((len2 >= 256) || (op_off+len1+20+len2 >= reqdir_off+resdir_length))
                continue;
            
            uint8_t *pbCertField = (uint8_t*)pRequirements + op_off + len1 + 20;
            
            char szCertField[256] = { 0 };
            memcpy(szCertField, pbCertField, len2);
            
            uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0,};
            CC_SHA256(szCertField, strlen(szCertField), digest);
            char hash[CC_SHA256_DIGEST_LENGTH * 2] = {0,};
            for (int i = 0; i < sizeof(digest); i++)
                sprintf(hash + (2 * i), "%02x", digest[i]);
            
            AGLog(@"binarySignerHash : %s", hash);
            AGLog(@"orgSignerHash    : %s", orgSigner);
            
            for (uint32_t n=0; n<len2; n++)
            {
                if (hash[n] != orgSigner[n]) // protector에서 넣어준 signer hash(orgSigner)와 비교함.
                {
                    AGLog(@"hash[n] != orgSigner[n]");
                    memcpy(binarySigner, pbCertField, len2);
                    return 10;
                }
            }
            return 0;
        }
    }
    return 0;
}


AG_INLINE int __CheckCodeSignature(const uint8_t *pbMachBuf, const uint8_t *pbDataBuf, uint32_t nDataSize, uint8_t * orgSigner, uint8_t * binarySigner)
{
    CS_SuperBlob *pSBlob = (CS_SuperBlob*)(pbDataBuf);
    if (OSSwapInt32(pSBlob->magic) != CSMAGIC_EMBEDDED_SIGNATURE)
    {
        AGLog(@"OSSwapInt32(pSBlob->magic) != CSMAGIC_EMBEDDED_SIGNATURE");
        return -1;
    }
    if (OSSwapInt32(pSBlob->length) > nDataSize)
    {
        AGLog(@"OSSwapInt32(pSBlob->length) > nDataSize");
        return -1;
    }
    CS_BlobIndex *pBlob = (CS_BlobIndex *)((uint8_t*)pSBlob + sizeof(CS_SuperBlob));
    uint32_t count = OSSwapInt32(pSBlob->count);
    
    for (uint32_t i=0; i<count; i++)
    {
        if ((OSSwapInt32(pBlob[i].type) == CSSLOT_REQUIREMENTS))
        {
            AGLog(@"CheckRequirements Start");
            int ret2 = CheckRequirements(pSBlob, &pBlob[i], orgSigner, binarySigner);
            if (ret2 > 0)
                return ret2;
        }
    }
    return 0;
}

AG_INLINE int _CheckCodeSignature64(const struct mach_header_64 *pHeader, uint8_t * orgSigner, uint8_t * binarySigner)
{
    const struct load_command *pCMD = (struct load_command*)(pHeader + 1);
    for (uint32_t i=0; i<pHeader->ncmds; i++)
    {
        if (pCMD == NULL)
            break;
        
        if (pCMD->cmd == LC_CODE_SIGNATURE)
        {
            AGLog(@"find LC_CODE_SIGNATURE");
            const struct linkedit_data_command  *pDC = (struct linkedit_data_command*)pCMD;
            return __CheckCodeSignature((uint8_t*)pHeader, (uint8_t*)pHeader + pDC->dataoff, pDC->datasize, orgSigner, binarySigner);
        }
        pCMD = (struct load_command*)((uint8_t*)pCMD + pCMD->cmdsize);
    }
    return 0;
}

AG_INLINE int _CheckCodeSignature(uint8_t * orgSigner, uint8_t * binarySigner)
{
    AGLog(@"orgSigner : %s", (char*)orgSigner);
    
    
    NSString    *bundlePath = [[NSBundle mainBundle] bundlePath];
    AGLog(@"bundlePath: %@", bundlePath);
    if ([bundlePath length] == 0) return -1;
    NSString    *BundleExecFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    AGLog(@"BundleExecFile: %@", BundleExecFile);
    if ([BundleExecFile length] == 0) return -1;
    
    NSString    *ExecFullPath = [NSString stringWithString:bundlePath];
    ExecFullPath = [ExecFullPath stringByAppendingPathComponent:BundleExecFile];
    AGLog(@"ExecFullPath: %@", ExecFullPath);
    
    
    NSError *err = nil;
    NSData  *FileDataBuf = [NSData dataWithContentsOfFile:ExecFullPath options:(NSDataReadingMapped) error:&err];
    if (!FileDataBuf) {
        AGLog(@"dataWithContentsOfFile: %@", err);
        return -1;
    }
    
    uint8_t *pbFileDataBuf = (uint8_t*)[FileDataBuf bytes];
    
    const struct fat_header *pHeader = (struct fat_header *)pbFileDataBuf;
    if (OSSwapInt32(pHeader->magic) == FAT_MAGIC)
    {
        AGLog(@"This is Fat");
        uint32_t nfat_arch = OSSwapInt32(pHeader->nfat_arch);
        for (uint32_t i=0; i<nfat_arch; i++)
        {
            const struct fat_arch *pArch;
            pArch = (const struct fat_arch*)((uint8_t*)pHeader + sizeof(struct fat_header) + (sizeof(struct fat_arch) * i));
            
            uint32_t offset = OSSwapInt32(pArch->offset);
            uint32_t mheader = *((uint32_t*)((uint8_t*)pHeader + offset));

            if (mheader == MH_MAGIC_64)
            {
                AGLog(@"MH_MAGIC_64 Start");
                const struct mach_header_64 *pMHeader = (const struct mach_header_64*)((uint8_t*)pHeader + offset);
                int ret2 = _CheckCodeSignature64(pMHeader, orgSigner, binarySigner);
                if (ret2 > 0)
                    return ret2;
            }
        }
    }
    else if (pHeader->magic == MH_MAGIC_64)
    {
        AGLog(@"This is MH_MAGIC_64");
        const struct mach_header_64 *pMHeader = (const struct mach_header_64*)((uint8_t*)pHeader);
        int ret2 = _CheckCodeSignature64(pMHeader, orgSigner, binarySigner);
        if (ret2 > 0)
            return ret2;
    }
    return 0;
}




#endif /* SignerCheck_h */
