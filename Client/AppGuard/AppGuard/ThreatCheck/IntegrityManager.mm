//
//  IntegrityManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 16/04/2019.
//  Copyright © 2019 nhnent. All rights reserved.
//

#include "IntegrityManager.hpp"
#include "EnvironmentManager.hpp"
#include "SignerCheck.h"


__attribute__((visibility("hidden"))) IntegrityManager::IntegrityManager() {
    memset(firstMemoryHash_, '\0', kTextSectionHashMaxLen);
    memset(textSectionHash, '\0', kTextSectionHashMaxLen);
}
__attribute__((visibility("hidden"))) IntegrityManager::~IntegrityManager() {
}

__attribute__((visibility("hidden"))) bool IntegrityManager::checkDylibInjection()
{
    bool result = false;
    int imageIndex = getTargetImageIndex();
    struct mach_header_64 * header = (struct mach_header_64 *)_dyld_get_image_header(imageIndex);
    int numberOfLoadCommandFromSDK = header->ncmds;
    char numberOfLoadCommandSignature[] = "123994885824959502021358544392924848949494112312348";
    if(CommonAPI::cStrstr(numberOfLoadCommandSignature, SECURE_STRING(CHECK_DYLIB_INJECTION_ERROR)))
    {
        // iOS Protector를 적용하지 않은 경우
        AGLog(@"numberOfLoadCommandSignature is not updated");
        return false;
    }
    int originalNumberOfLoadCommand = atoi(numberOfLoadCommandSignature);
    AGLog(@"originalNumberOfLoadCommand : %d", originalNumberOfLoadCommand);
    AGLog(@"numberOfLoadCommandFromSDK  : %d", numberOfLoadCommandFromSDK);
    if(originalNumberOfLoadCommand != numberOfLoadCommandFromSDK)
    {
        result = true;
    }
    return result;
}


__attribute__((visibility("hidden"))) int IntegrityManager::getTargetImageIndex()
{
    uint32_t imageCount = _dyld_image_count();

    int imageIndex = Util::getImageNumber();

    for(int i=0; i<imageCount; i++)
    {
        const char * name = _dyld_get_image_name(i);
        if(CommonAPI::cStrstr(name, SECURE_STRING(UnityFramework)))
        {
            AGLog(@"Found UnityFramework");
            imageIndex = i; // Target is unity
            break;
        }
    }
    return imageIndex;
}


/*
* 다음은 UnityFramework 바이너리 내부에 존재하는 text section(코드영역)의 hash 값을 추출하여 무결성을 검증하기위한 함수입니다.
* 주의) python3으로 개발된 'Protector'와 같이 사용해야하는 함수입니다.
*/
#define NULL_PADDING 1
__attribute__((visibility("hidden"))) bool IntegrityManager::checkUnityFramework()
{
    bool result = false;
    int unityIndex = getTargetImageIndex();
    if(unityIndex == -1)
    {
        return false;
    }
    
    char unityTextSectionHashBySDK[(CC_SHA256_DIGEST_LENGTH * 2) + NULL_PADDING] = {'\0'};
    char unityIl2cppSectionHashBySDK[(CC_SHA256_DIGEST_LENGTH * 2) + NULL_PADDING] = {'\0'};
    
    makeTextSegmentSectionSha256BySectionName(unityTextSectionHashBySDK, unityIndex, SECURE_STRING(__text));
    makeTextSegmentSectionSha256BySectionName(unityIl2cppSectionHashBySDK, unityIndex, SECURE_STRING(section_name_il2cpp));
    
    result = checkOrignalUnityHash(unityTextSectionHashBySDK, unityIl2cppSectionHashBySDK);

    return result;
}

__attribute__((visibility("hidden"))) bool IntegrityManager::checkOrignalUnityHash(const char* textSectionHashBySDK, const char* il2cppSectionHashBySDK) {
    bool result = false;
 
    char unityTextSectionHashSignature[] = {
        "b4b1a8044432305ce232da3cba98bed4560585789c227c231acf8c235a2641d3"
    };
    
    if(CommonAPI::cStrstr(unityTextSectionHashSignature, SECURE_STRING(UnityHashSignatureCheck))) {
        AGLog(@"unity_hash_signature is not updated");
        return false;
    }
    
    AGLog(@"[+] unityHashBySDK: %s", textSectionHashBySDK);
    AGLog(@"[+] unity_text_hash_signature: %s", unityTextSectionHashSignature);
    
    if(CommonAPI::cStrcmp(textSectionHashBySDK, unityTextSectionHashSignature) == 0) {
        AGLog(@"[+] UNITY __text section IS VALID");
        result = false;
    } else {
        AGLog(@"[+] UNITY __text section IS INVALID");
        result = true;
    }
    
    // __text섹션이 유효할 경우 il2cpp를 검증.
    // il2cpp섹션의 해시를 구할 수 있는 경우
    if(result == false && CommonAPI::cStrlen(il2cppSectionHashBySDK) != 0) {
        char unityIl2cppSectionHashSignature[] = {
            "d64b7b73d0b162775e0873719d3ae589873238850ce9eb200d7e0bb9d0b895d8"
        };
        
        if(CommonAPI::cStrstr(unityIl2cppSectionHashSignature, SECURE_STRING(UnityIl2cppSignatureCheck)) == NULL) {
          
            AGLog(@"[+] il2cppSectionHashBySDK: %s", il2cppSectionHashBySDK);
            AGLog(@"[+] unity_il2cpp_signature: %s", unityIl2cppSectionHashSignature);
            
            if(CommonAPI::cStrcmp(il2cppSectionHashBySDK, unityIl2cppSectionHashSignature) == 0) {
                AGLog(@"[+] UNITY il2cpp section IS VALID");
                result = false;
            } else {
                AGLog(@"[+] UNITY il2cpp section IS INVALID");
                result = true;
            }
        } else {
            AGLog(@"unity il2cpp hash signature is not updated.");
        }
    }

    return result;
}
__attribute__((visibility("hidden"))) void IntegrityManager::makeTextSegmentSectionSha256BySectionName(char * result, int imageIndex, const char* sectionName) {
    
    AGLog(@"makeTextSegmentSectionSha256 section=%s START", sectionName);
    
    struct mach_header_64 * header = (struct mach_header_64 *)_dyld_get_image_header(imageIndex);
    struct load_command * lc_cmd = (struct  load_command*)(header + 1);
    struct segment_command_64 * segment;
        
    for(int i = 0; i < header->ncmds; i++) {
        segment = (struct segment_command_64 *)lc_cmd;
        if( segment->cmd == LC_SEGMENT_64 ) {
            // TEXT 세그먼트를 찾기 위한 로직
            if(CommonAPI::cStrcmp(segment->segname, SECURE_STRING(text_segment)) == 0) {
                struct section_64 * section = (struct section_64 *)(segment +1);
                for(int j=0; j< segment->nsects; j++) {
                    // 섹션 이름으로 찾음.
                    if(CommonAPI::cStrcmp(section->sectname, sectionName) == 0) {
                        AGLog(@"Segment Name : %s", segment->segname);
                        AGLog(@"Section Name : %s", section->sectname);
                        AGLog(@"Section Size : %llu", section->size);
                        
                        uint64_t sectionSize = section->size;
                        uint8_t * sectionPtr = (uint8_t *)((uint64_t)header + section->addr - segment->vmaddr);
                        
                        uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
                        CC_SHA256(sectionPtr, (CC_LONG)sectionSize, digest); // text 섹션의 sha256해싱
                        
                        for (int i = 0; i < sizeof(digest); i++) {
                            sprintf(result + (2 * i), "%02x", digest[i]);
                        }
                        AGLog(@"makeTextSegmentSectionSha256 section=%s hash=%s", sectionName, result);
                        return;
                    }
                    section = section + 1;
                }
            }
        }
        lc_cmd = (struct  load_command*)((uint8_t*)lc_cmd + segment->cmdsize);
    }
    return;
}

/*
* 다음은 앱 바이너리 내부에 존재하는 text section(코드영역)의 hash 값을 추출하여 무결성을 검증하기위한 함수입니다.
* 주의) python3으로 개발된 'Protector'와 같이 사용해야하는 함수입니다.
*/
__attribute__((visibility("hidden"))) bool IntegrityManager::checkTextSectionHashByProtector()
{
    //TODO: strstr보다 strcmp로 섹션, 세그먼트 이름을 매칭해야함.
    
    bool result = false;
    AGLog(@"checkTextSectionHashByProtector START");

    int imageIndex = Util::getImageNumber();

    AGLog(@"[+] imageIndex : %d \n", imageIndex);
    struct mach_header_64 * header = (struct mach_header_64 *)_dyld_get_image_header(imageIndex);
    struct load_command * lc_cmd = (struct  load_command*)(header + 1);
    struct segment_command_64 * segment;
    for(int i = 0; i < header->ncmds; i++)
    {
        segment = (struct segment_command_64 *)lc_cmd;
        if( segment->cmd == LC_SEGMENT_64 )
        {
            // 텍스트 세그먼트를 찾기 위한 로직
            if(CommonAPI::cStrstr(segment->segname, SECURE_STRING(text_segment)) )
            {
                struct section_64 * section = (struct section_64 *)(segment +1);
                for(int j=0; j< segment->nsects; j++ )
                {
                    // 텍스트 섹션을 찾기 위한 로직
                    if(CommonAPI::cStrstr(section->sectname, SECURE_STRING(__text)))
                    {
                        AGLog(@"Segment Name : %s", segment->segname);
                        AGLog(@"Section Name : %s", section->sectname);
                        AGLog(@"Section Size : %llu", section->size);
                        
                        uint64_t textSectionSize = section->size;
                        uint8_t * textSectionPtr = (uint8_t *)((uint64_t)header + section->addr - segment->vmaddr);
                        
                        uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0,};
                        CC_SHA256(textSectionPtr, (CC_LONG)textSectionSize, digest); // text 섹션의 sha256해싱
                        char hash[CC_SHA256_DIGEST_LENGTH * 2] = {0,}; //TODO: null문자 추가 버퍼가 필요함 +1
                        for (int i = 0; i < sizeof(digest); i++)
                            sprintf(hash + (2 * i), "%02x", digest[i]);
                        
                        
                        /* 
                        * Description:
                        *   hash_by_appguard_web 변수("0445c...")에 저장되어있는 offset을 python3으로 개발된 'Protector'가 찾은 뒤,
                        *   해당 값을 앱의 text section 의 해시값으로 update 합니다. 
                        *   즉 'Protector'를 적용한 뒤에는 hash_by_appguard_web 변수에 text section의 해시값이 저장되어있습니다.
                        *   "0445c..."와 같은 기본값을 가지고 있는 이유는 'Protector'에서 offset을 찾기 위함입니다.
                        */
                        char hash_signature[] =
                        {
                            "0445c8014433305ce142da3cba9cbed456d585789c224c231a3f8c205b9643dd"
                        };
                        hash_signature[CC_SHA256_DIGEST_LENGTH * 2] = NULL; //TODO: 문맥상 '\0'를 넣어야함.
                        AGLog(@"[+] hash              : %s \n", hash);
                        
                        // 앱가드 프로텍터 적용이 제대로 안된 경우 함수종료;
                        if(CommonAPI::cStrstr(hash_signature, SECURE_STRING(CHECK_PROTECT_ERROR_STRING))) return false;
                            
                        if(CommonAPI::cStrstr(hash, hash_signature))
                        {
                            AGLog(@"[+] VALID");
                            result = false;
                        } else
                        {
                            //Knwon Issue:Debug모드에서 breakpoint 활성화시 software breakpoint를 위해 opcode가 수정되어 hash가 불일치하게됨.
                            AGLog(@"[+] NOT VALID");
                            result = true;
                        }
                        AGLog(@"[+] hash_by_protector : %s \n", hash_signature);
                        return result;
                    }
                    section = section + 1;
                }
            }
        }
        lc_cmd = (struct  load_command*)((uint8_t*)lc_cmd + segment->cmdsize);
    }
    
    return false;
}




// @author  : junyeong Lee
// @return  : 서명 정보 무결성 검증의 결과값
// @brief   : 서명 무결성 검증 함수
__attribute__((visibility("hidden"))) uint8_t* IntegrityManager::checkSigner()
{
    NSString * nsSigner = STInstance(EnvironmentManager)->getSigner();
    if(nsSigner == nullptr)
    {
        AGLog(@"nsSigner == NULL");
        return nullptr;
    }
    uint8_t* signer = (uint8_t*)NS2CString(nsSigner);
    _CheckCodeSignature(signer, binarySigner);
    if(binarySigner[0] != 0){
        return (uint8_t*)binarySigner;
    }
    return nullptr;
}


// @author  : daejoon kim
// @return  : 텍스트 섹션 검사 결과
// @brief   : 텍스트 섹션 검사
__attribute__((visibility("hidden"))) bool IntegrityManager::checkTextSectionHash() {
    bool result = false;
#ifdef DEBUG
    int imageNumber = Util::getImageNumber();
#else
    int imageNumber = 0;
#endif
    AGLog(@"Image Number - [%d]", imageNumber);
    if(imageNumber != -1) {
        void* imageHeader = (void*)_dyld_get_image_header(imageNumber);
        if(firstExecute) {
            memset(firstMemoryHash_,'\0', kTextSectionHashMaxLen);
            getTextSectionHash(imageHeader, firstMemoryHash_, kTextSectionHashMaxLen);
            AGLog(@"First memory hash - [%s]", firstMemoryHash_);
            firstExecute = false;
        }
        
        if(STInstance(CommonAPI)->cStrlen(firstMemoryHash_) != 0)
        {
            char memoryHash[kTextSectionHashMaxLen] = {'\0',};
            if(getTextSectionHash(imageHeader, memoryHash, kTextSectionHashMaxLen))
            {
                AGLog(@"memory hash - [%s]", memoryHash);
                if(STInstance(CommonAPI)->cStrncmp(firstMemoryHash_, memoryHash, strlen(firstMemoryHash_))!= 0) {
                    memcpy(textSectionHash, memoryHash, kTextSectionHashMaxLen);
                    AGLog(@"Not same hash - first:[%s] current:[%s]", firstMemoryHash_, memoryHash);
                    result = true;
                } else {
                    AGLog(@"Same hash - first:[%s] current:[%s]", firstMemoryHash_, memoryHash);
                }
            }
        }
    }

    return result;
}

// @author  : daejoon kim
// @return  : 설치 빌드 해시와 서명 해시의 동일 유무 결과값
// @brief   : 해시 검증을 위한 메인 함수
__attribute__((visibility("hidden"))) bool IntegrityManager::checkCodeSignatureHash()
{
    bool result = false;
    NSString * excuteFilePath = Util::getExecuteFilePath();
    AGLog(@"Excute file path - [%@]", excuteFilePath);
    if(excuteFilePath != NULL)
    {
        int fd = open(NS2CString(excuteFilePath), O_RDONLY);
        if(fd != -1)
        {
            size_t mapSize = Util::getFileSizeByFstat(fd);
            AGLog(@"Map size - [%d]", (int)mapSize);
            void * appBinary = mmap(0, mapSize, PROT_READ, MAP_SHARED, fd, 0); // 파일을 메모리에 맵핑
            if(appBinary != MAP_FAILED) // 메모리에 맵핑되지 않은면 탐지 못함
            {
                iOSFormat formatNumber = checkFileFormat(appBinary);
                if(formatNumber == kFAT) // fat일 경우
                {
                    AGLog(@"Arch : FAT");
                    result = checkCodeHashOfFAT(appBinary);
                }
                else if(formatNumber == kMachO) // mach-o일 경우
                {
                    AGLog(@"Arch : MachO");
                    result = checkCodeHash(appBinary);
                }
                munmap(appBinary, mapSize);
            }
            close(fd);
        }
    }

    return result;
}

// @author  : daejoon kim
// @return  : iOS 파일 포맷 타입
// @brief   : iOS 파일 포맷 확인
__attribute__((visibility("hidden"))) iOSFormat IntegrityManager::checkFileFormat(void * addr)
{
    iOSFormat formatResult = kNone;
    const uint32_t * magic  = (const uint32_t*)addr;
    
    if(*magic == FAT_CIGAM || *magic == FAT_MAGIC || *magic == FAT_CIGAM_64 || *magic == FAT_MAGIC_64) // fat인지 확인
    {
        AGLog(@"FAT");
        formatResult = kFAT;
    }
    else if(*magic == MH_CIGAM || *magic == MH_MAGIC || *magic == MH_CIGAM_64 || *magic == MH_MAGIC_64) // mach-o인지 확인
    {
        AGLog(@"Mach-o");
        formatResult = kMachO;
    }
    return formatResult;
}

// @author  : daejoon kim
// @return  : 로드커맨드 오프셋
// @brief   : 아키텍쳐 로드커맨드 오프셋 전달
__attribute__((visibility("hidden"))) size_t IntegrityManager::getLoadCommandOffset(uint32_t magic)
{
    if(magic == MH_CIGAM_64 || magic == MH_MAGIC_64)
    {
        AGLog(@"64bit");
        return sizeof(struct mach_header_64);
    }
    AGLog(@"32bit");
    return sizeof(struct mach_header);
}

// @author  : daejoon kim
// @return  : 각 아키텍쳐의 해시의 무결성 유무
// @brief   : 각 아키텍쳐의 해시 검사
__attribute__((visibility("hidden"))) bool IntegrityManager::checkCodeHashOfFAT(void * addr)
{
    bool result = false;
    const struct fat_header * fatHeader = (const struct fat_header*)(addr);
    uint32_t nFatArch = OSSwapBigToHostInt32(fatHeader->nfat_arch); // 아키텍쳐 갯수를 가져옴 (fat 안에 각 아키텍쳐별 mach-o가 있음)
    void * fatArchAddr = (void*)((unsigned char*)addr + sizeof(struct fat_header));
    for(uint32_t i = 0; i < nFatArch; i++)
    {
        const struct fat_arch * fatArch = (const struct fat_arch*)fatArchAddr;
        uint32_t archOffset = OSSwapBigToHostInt32(fatArch->offset); // 아키텍쳐의 오프셋을 옴가져옴 (32bit, 64bit 호환)
        if(checkCodeHash((unsigned char*)addr + archOffset)) // 코드 해시 검사
        {
            AGLog(@"Not same hash");
            result = true; // 해시가 틀리면 ture로 변경
            break;
        }
        fatArchAddr = (void*)((unsigned char*)fatArchAddr + sizeof(struct fat_arch)); // 다음 아키텍쳐로 이동
    }

    return result;
}

// @author  : daejoon kim
// @return  : 텍스트 섹션의 해시값 (SHA1)
// @brief   : 텍스트 섹션의 해시값을 구하여 전달
__attribute__((visibility("hidden"))) bool IntegrityManager::getTextSectionHash(void* addr, char* const hashBuf, size_t buflen)
{
    bool result = false;
    if(buflen < kTextSectionHashMaxLen) {
        AGLog(@"Hahs Buffer Length < kTextSectionHashMaxLen");
        return result;
    }
    
#if __LP64__
    const struct mach_header * header = (const struct mach_header*)addr;
    struct load_command * cmd = (struct load_command *)((unsigned char*)header + getLoadCommandOffset(header->magic));
    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++)
    {
        if(cmd->cmd == LC_SEGMENT_64)  // 64bit 세그먼트를 찾음
        {
            AGLog(@"Found - LC_SEGMENT_64");
            struct segment_command_64 * segment = (struct segment_command_64 *)cmd;
            if (!STInstance(CommonAPI)->cStrcmp(segment->segname, SECURE_STRING(text_segment))) // text 세그먼트를 찾음
            {
                AGLog(@"Found - Text Segment");
                struct section_64 * section = (struct section_64 *)(segment + 1);
                for (uint32_t j = 0; section != NULL && j < segment->nsects; j++) {
                    if (!STInstance(CommonAPI)->cStrcmp(section->sectname, SECURE_STRING(__text)))  // text 섹션을 찾음
                    {
                        AGLog(@"Found - Text Section");
                        break;
                    }
                    section = (struct section_64 *)(section + 1);
                }
                uint64_t textSectionAddr = (uint64_t)section->addr;
                uint64_t textSectionSize = section->size;
                uint64_t vmaddr = segment->vmaddr;
                unsigned char * textSectionPtr = (unsigned char *)((uint64_t)header + textSectionAddr - vmaddr); // text 센션의 주소를 구함
                uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0,};
                CC_SHA1(textSectionPtr, (CC_LONG)textSectionSize, digest); // text 섹션의 sha1 해싱
                memset(hashBuf, '\0', buflen);
                for (int i = 0; i < sizeof(digest); i++)
                    sprintf(hashBuf + (2 * i), "%02x", digest[i]);
                result = true;
                AGLog(@"Arch : [64] Address : [%p] Hash Value : [%s]", addr, hashBuf);
                return result;
            }
        }
        cmd = (struct load_command *)((uint8_t *)cmd + cmd->cmdsize);
    }
    return result;
#else
    const struct mach_header * header = (const struct mach_header*)addr;
    struct load_command * cmd = (struct load_command *)((unsigned char*)header + getLoadCommandOffset(header->magic));
    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++)
    {
        if (cmd->cmd == LC_SEGMENT) // 32bit 세그먼트를 찾음
        {
            AGLog(@"Found - LC_SEGMENT");
            struct segment_command * segment = (struct segment_command *)cmd;
            if (!strcmp(segment->segname, SECURE_STRING(text_segment)))  // text 세그먼트를 찾음
            {
                AGLog(@"Found - Text Segment");
                struct section * section = (struct section *)(segment + 1);
                for (uint32_t j = 0; section != NULL && j < segment->nsects; j++)
                {
                    if (!strcmp(section->sectname, SECURE_STRING(__text))) // text 섹션을 찾음
                    {
                        AGLog(@"Found - Text Section");
                        break;
                    }
                    
                    section = (struct section *)(section + 1);
                }
                uint32_t textSectionAddr = (uint32_t)section->addr;
                uint32_t textSectionSize = section->size;
                uint32_t vmaddr = segment->vmaddr;
                unsigned char * textSectionPtr = (unsigned char *)((unsigned char*)header + textSectionAddr - vmaddr);  // text 센션의 주소를 구함
                uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0,};
                CC_SHA1(textSectionPtr, (CC_LONG)textSectionSize, digest); // text 섹션의 sha1 해싱
                memset(hashBuf, '\0', buflen);
                for (int i = 0; i < sizeof(digest); i++)
                    sprintf(hashBuf + (2 * i), "%02x", digest[i]);
                result = true;
                AGLog(@"Arch : [32] Address : [%p] Hash Value : [%s]", addr, hashBuf);
                return result;
            }
        }
        cmd = (struct load_command *)((uint8_t *)cmd + cmd->cmdsize);
    }
    return result;
#endif
}

// @author  : daejoon kim
// @return  : 코드 해시 검사 결과
// @brief   : 코드 해시 검사
__attribute__((visibility("hidden"))) bool IntegrityManager::checkCodeHash(void * addr)
{
    bool result = false;
    const struct mach_header * header = (const struct mach_header*)addr;
    struct load_command * cmd = (struct load_command *)((unsigned char*)header + getLoadCommandOffset(header->magic));
    
    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++)
    {
        if(cmd->cmd == LC_CODE_SIGNATURE) // Signature 로드커맨드를 찾음
        {
            AGLog(@"Found - LC_CODE_SIGNATURE");
            struct linkedit_data_command * codeSignatureCommand = (struct linkedit_data_command*)cmd;
            
            const CS_SuperBlob * codeEmbedded = (const CS_SuperBlob*)((unsigned char*)header + codeSignatureCommand->dataoff); // 임베디드 코드를 가져옴
            const CS_BlobIndex currentIndex = codeEmbedded->index[0]; // 첫번째 임베디드 코드를 가져옴
            const CS_CodeDirectory * codeDirectory = (const CS_CodeDirectory*)((unsigned char*)codeEmbedded + ntohl(currentIndex.offset)); // 코드 디렉토리를 가져옴 (첫번째 임베디드 코드의 오프셋으로 이동
            
            unsigned int pageSize = codeDirectory->pageSize ? (1 << codeDirectory->pageSize) : 0; // 코드 디렉토리의 페이지 사이즈를 가져옴
            unsigned int codeSlots = OSSwapInt32(codeDirectory->nCodeSlots); // 코드 슬롯 갯수를 가져옴
            unsigned int remaining = OSSwapInt32(codeDirectory->codeLimit); // 코드 제한을 가져옴
            AGLog(@"page size - [%d]", pageSize);
            AGLog(@"code slot num - [%d]", codeSlots);
            AGLog(@"code limit - [%d]", remaining);

            unsigned int processed = 0; // 진행중인 사이즈
            for(int slot = 0; slot < codeSlots; ++slot)
            {
                int size = MIN(remaining, pageSize); // 사이즈 확인
                if(size == 0) // 남은 사이즈가 있는지 확인
                {
                    break;
                }
                
                if(!compareCodeHash((void*)((unsigned char*)header + processed), size, slot, codeDirectory)) // 해시 비교
                {
                    
                    AGLog(@"Not same hash - slot number - [%d] processed - [%d] remaining - [%d] size - [%d]", slot, processed, remaining, size);
                    result = true;
                    break;
                }
                processed += size; // 진행 코드 증가
                remaining -= size; // 남은 코드 감소
            }  
        }
        cmd = (struct load_command *)((uint8_t *)cmd + cmd->cmdsize);
    }

    return result;
}

// @author  : daejoon kim
// @return  : 코드 해시 비교 결과
// @brief   : 코드 해시 비교
__attribute__((visibility("hidden"))) char IntegrityManager::compareCodeHash(const void* data, size_t length, size_t slot, const CS_CodeDirectory* codeDirectory)
{
    uint32_t hashSize = codeDirectory->hashSize;
    uint8_t  hashType = codeDirectory->hashType;
    void * binaryHash = NULL;
    
    if(hashType == cdHashTypeSHA1){
        uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0,};
        CC_SHA1(data, (CC_LONG)length, digest); // 바이너리 sha1 해싱
        binaryHash = digest;
    
    }else if(hashType == cdHashTypeSHA256){
        uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0,};
        CC_SHA256(data, (CC_LONG)length, digest); // 바이너리 sha256 해싱
        binaryHash = digest;
    }else{
        return 1; // 해싱 알고리즘이 sha1, sha256 이외의 것이 사용된 경우 skip
    }
    void* codeDirectoryHash = (void*)((char*)codeDirectory + ntohl(codeDirectory->hashOffset) + hashSize * slot); // 저장된 코드 디렉토리의 해시를 가져옴
    return (memcmp(binaryHash, codeDirectoryHash, hashSize) == 0); // 바이너리 해시와 저장된 코드 디렉토리 해시를 비교
}

/*
 참고 사이트 : https://stackoverflow.com/questions/29598313/checking-code-integrity-in-ios
 일단 보류  : 개발자 테스트 빌드, 복호화된 빌드는 암호화가 되어있지 않음
 앱스토어에 배포 빌드는 암호화가 되어있음
 배포된 빌드의 로그를 확인 후 적용할 예정
 */
// @author  : daejoon kim
// @return  : mach-o가 암호화 유무 결과값
// @brief   : mach-o가 암호화 되어 있는지 확인
__attribute__((visibility("hidden"))) bool IntegrityManager::checkCryptId()
{
    bool result = false;
    NSString * excuteFilePath = Util::getExecuteFilePath();
    AGLog(@"Excute file path - [%@]", excuteFilePath);
    if(excuteFilePath != NULL)
    {
        int fd = open(NS2CString(excuteFilePath), O_RDONLY);
        if(fd != -1)
        {
            size_t mapSize = Util::getFileSizeByFstat(fd);
            AGLog(@"Map size - [%d]", (int)mapSize);
            void * appBinary = mmap(0, mapSize, PROT_READ, MAP_SHARED, fd, 0); // 파일을 메모리에 맵핑
            if(appBinary != MAP_FAILED) // 메모리에 맵핑되지 않은면 탐지 못함
            {
                iOSFormat formatNumber = checkFileFormat(appBinary);
                if(formatNumber == kFAT) // fat일 경우
                {
                    AGLog(@"Arch : FAT");
                    result = checkCryptIdOfFAT(appBinary);
                }
                else if(formatNumber == kMachO) // mach-o일 경우
                {
                    AGLog(@"Arch : MachO");
                    result = checkCryptIdOfMachO(appBinary);
                }
                munmap(appBinary, mapSize);
            }
            close(fd);
        }
    }
    
    return result;
}

__attribute__((visibility("hidden"))) bool IntegrityManager::checkCryptIdOfFAT(void* addr)
{
    bool result = false;
    const struct fat_header * fatHeader = (const struct fat_header*)(addr);
    uint32_t nFatArch = OSSwapBigToHostInt32(fatHeader->nfat_arch); // 아키텍쳐 갯수를 가져옴 (fat 안에 각 아키텍쳐별 mach-o가 있음)
    void * fatArchAddr = (void*)((unsigned char*)addr + sizeof(struct fat_header));
    AGLog(@"Arch Number - [%d]", nFatArch);
    for(uint32_t i = 0; i < nFatArch; i++)
    {
        const struct fat_arch * fatArch = (const struct fat_arch*)fatArchAddr;
        uint32_t archOffset = OSSwapBigToHostInt32(fatArch->offset); // 아키텍쳐의 오프셋을 옴가져옴 (32bit, 64bit 호환)
        if(checkCryptIdOfMachO((unsigned char*)addr + archOffset))
        {
            result = true;
            break;
        }
        fatArchAddr = (void*)((unsigned char*)fatArchAddr + sizeof(struct fat_arch)); // 다음 아키텍쳐로 이동
    }

    return result;
}

__attribute__((visibility("hidden"))) bool IntegrityManager::checkCryptIdOfMachO(void* addr)
{
    bool result = false;
    struct mach_header * header = (struct mach_header * )addr;
    struct load_command * cmd = (struct load_command *)((unsigned char*)header + getLoadCommandOffset(header->magic));
    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++)
    {
        if(cmd->cmd == LC_ENCRYPTION_INFO || cmd->cmd == LC_ENCRYPTION_INFO_64) // ENCRYPTION INFO 커맨드 확인
        {
            AGLog(@"Found - LC_ENCRYPTION_INFO / LC_ENCRYPTION_INFO_64");
            struct encryption_info_command * cryptCommand = (struct encryption_info_command*) cmd;
            if(cryptCommand->cryptid != 1) // cryptid 확인 (1 = 암호화o, 1 != 암호화x)
            {
                AGLog(@"No encrypt binary");
                result = true;
            }
        }
        cmd = (struct load_command *)((uint8_t *)cmd + cmd->cmdsize);
    }

    return result;
}

__attribute__((visibility("hidden"))) const char* IntegrityManager::getTextSectionHash()
{
    return textSectionHash;
}
