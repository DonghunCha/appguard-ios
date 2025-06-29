//
//  TweakManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 2020/07/28.
//  Copyright © 2020 nhnent. All rights reserved.
//

#include "TweakManager.hpp"

__attribute__((visibility("hidden"))) void TweakManager::removeTweakA()
{
    char* tweakPath = Util::checkDynamicLibrary(SECURE_STRING(dynamic_libraries), STInstance(EnvironmentManager)->getPackageInfo().c_str(), SECURE_STRING(plist));
    if(tweakPath != NULL)
    {
        AGLog(@"Tweak Path - [%s]", tweakPath);
        NSOperationQueue *tweakRemoveQueueA = [[NSOperationQueue alloc] init];
        [tweakRemoveQueueA addOperationWithBlock:^{
            // block로그 전송 전 crash되어 로그 누락이 생길 수 있으므로 2초 정도 후 removeTextSection 수행
            // https://nhnent.dooray.com/project/tasks/4048087997829175519
            STInstance(CommonAPI)->stdSleepFor(2);//block로그 전송 전 crash되어 로그 누락이 생길 수 있으므로 2초 정도 후 removeTextSection 수행
            removeTextSection(tweakPath);
        }];
    }
}

__attribute__((visibility("hidden"))) void TweakManager::removeTextSection(char* path)
{
    char* name = getTweakName(path);
    AGLog(@"Tweak Name - [%s]", name);
    if(name != NULL)
    {
        int imageNumber = getTweakImageNumger(name);
        if(imageNumber != -1)
        {
            void* imageHeader = (void*)_dyld_get_image_header(imageNumber);
            AGLog(@"Tweak Address - [%p]", imageHeader);
            removeA(imageHeader);
        }
    }
}

__attribute__((visibility("hidden"))) char* TweakManager::getTweakName(char* path)
{
    char* name = strtok(path, "/");
    for (int i=0; i<3; i++)
    {
        name = strtok(NULL, "/");
    }
    return name;
}

__attribute__((visibility("hidden"))) void TweakManager::removeTweakB()
{
    char* tweakPath = Util::checkDynamicLibrary(SECURE_STRING(dynamic_libraries), STInstance(EnvironmentManager)->getPackageInfo().c_str(), SECURE_STRING(plist));
    if(tweakPath != NULL)
    {
        AGLog(@"Tweak Path - [%s]", tweakPath);
        NSOperationQueue *tweakRemoveQueueB = [[NSOperationQueue alloc] init];
        [tweakRemoveQueueB addOperationWithBlock:^{
            removeTextSection(tweakPath);
        }];
    }
}

__attribute__((visibility("hidden"))) int TweakManager::getTweakImageNumger(char* name)
{
    int result = -1;
    for(int i = 0; i < _dyld_image_count(); i++)
    {
        const char* imageName = (char*)_dyld_get_image_name(i);
        if(STInstance(CommonAPI)->cStrstr(imageName, name) != NULL)
        {
            AGLog(@"Find image : [%s] number : [%d]",imageName, i);
            result = i;
            break;
        }
    }
    return result;
}

__attribute__((visibility("hidden"))) void TweakManager::removeA(void* addr)
{
#if __LP64__
    const struct mach_header * header = (const struct mach_header*)addr;
    struct load_command * cmd = (struct load_command *)((unsigned char*)header + sizeof(struct mach_header_64));
    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++)
    {
        if(cmd->cmd == LC_SEGMENT_64)
        {
            struct segment_command_64 * segment = (struct segment_command_64 *)cmd;
            if (!STInstance(CommonAPI)->cStrcmp(segment->segname, SECURE_STRING(text_segment)))
            {
                struct section_64 * section = (struct section_64 *)(segment + 1);
                for (uint32_t j = 0; section != NULL && j < segment->nsects; j++) {
                    if (!STInstance(CommonAPI)->cStrcmp(section->sectname, SECURE_STRING(__text)))
                    {
                        break;
                    }
                    section = (struct section_64 *)(section + 1);
                }
                uint64_t textSectionAddr = (uint64_t)((intptr_t)header + section->offset);
                uint64_t textSectionSize = section->size;
                AGLog(@"addr : [%p] size : [%d]", (void*)textSectionAddr, (unsigned int)textSectionSize);
                unsigned char * textSectionPtr = (unsigned char*)textSectionAddr;
                int removeCount = ((int)textSectionSize/4)-1;
                for(int i = 0; i < removeCount; i++)
                {
                    if(writeData((vm_address_t)textSectionPtr, 0x00000000) != true)
                    {
                        AGLog(@"Fail Nop - [%p]", textSectionPtr);
                    }
                    textSectionPtr += 4;
                }
                break;
            }
        }
        cmd = (struct load_command *)((uint8_t *)cmd + cmd->cmdsize);
    }
#endif
}

__attribute__((visibility("hidden"))) void TweakManager::removeAllTweakA()
{
    NSOperationQueue *tweakAllRemoveQueueA = [[NSOperationQueue alloc] init];
    [tweakAllRemoveQueueA addOperationWithBlock:^{
        uint32_t count = _dyld_image_count();
        for(uint32_t i = 0; i < count; i++)
        {
            const char* dyld = _dyld_get_image_name(i);
            if(CommonAPI::cStrstr(dyld, SECURE_STRING(dynamic_libraries)))
            {
                AGLog(@"Find : [%s]", dyld);
                AGLog(@"Tweak Address - [%p]", (void*)_dyld_get_image_header(i));
                removeA((void*)_dyld_get_image_header(i));

            }
        }
    }];
}

__attribute__((visibility("hidden"))) void TweakManager::removeB(void* addr)
{
#if __LP64__
    const struct mach_header_64 * header = (const struct mach_header_64*)addr;
    const struct section_64 * section = getsectbynamefromheader_64(header, SECURE_STRING(text_segment), SECURE_STRING(__text));

    uint64_t textSectionAddr = (uint64_t)((intptr_t)header + section->offset);
    uint64_t textSectionSize = section->size;
    AGLog(@"addr : [%p] size : [%d]", (void*)textSectionAddr, (unsigned int)textSectionSize);
    unsigned char * textSectionPtr = (unsigned char *)textSectionAddr;
    int removeCount = ((int)textSectionSize/4)-1;
    for(int i = 0; i < removeCount; i++)
    {
        if(writeData((vm_address_t)textSectionPtr, 0x00000000) != true)
        {
            AGLog(@"Fail Nop - [%p]", textSectionPtr);
        }
        textSectionPtr += 4;
    }
#endif
}

__attribute__((visibility("hidden"))) void TweakManager::removeAllTweakB()
{
    NSOperationQueue *tweakAllRemoveQueueB = [[NSOperationQueue alloc] init];
    [tweakAllRemoveQueueB addOperationWithBlock:^{
        Dl_info dylibInfo;
        uint32_t count = _dyld_image_count();
        for(uint32_t i = 0; i < count; i++)
        {
            dladdr(_dyld_get_image_header(i), &dylibInfo);
            if(CommonAPI::cStrstr(dylibInfo.dli_fname, SECURE_STRING(dynamic_libraries)))
            {
                AGLog(@"Find : [%s]", dylibInfo.dli_fname);
                AGLog(@"Tweak Address - [%p]", (void*)_dyld_get_image_header(i));
                removeB((void*)_dyld_get_image_header(i));
            }
        }
    }];
}

__attribute__((visibility("hidden"))) bool TweakManager::getType(unsigned int data)
{
    int a = data & 0xffff8000;
    int b = a + 0x00008000;
    int c = b & 0xffff7fff;
    return c;
}

__attribute__((visibility("hidden"))) bool TweakManager::writeData(vm_address_t offset,  unsigned int data)
{
    kern_return_t err;
    mach_port_t port = mach_task_self();
    vm_address_t address = offset;

    err = vm_protect(port, (vm_address_t) address, sizeof(data), NO, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    if(err != KERN_SUCCESS)
    {
        return false;
    }
    
    if(getType(data))
    {
        data = CFSwapInt32(data);
        err = vm_write(port, address, (vm_address_t)&data, sizeof(data));
    }
    else
    {
        data = (unsigned short)data;
        data = CFSwapInt16(data);
        err = vm_write(port, address, (vm_address_t)&data, sizeof(data));
    }
    
    if(err != KERN_SUCCESS)
    {
        return false;
    }
    err = vm_protect(port, (vm_address_t)address, sizeof(data), NO,VM_PROT_READ | VM_PROT_EXECUTE);
    return true;
}

__attribute__((visibility("hidden"))) void TweakManager::removeTweakC()
{
    char* tweakPath = Util::checkDynamicLibrary(SECURE_STRING(dynamic_libraries), STInstance(EnvironmentManager)->getPackageInfo().c_str(), SECURE_STRING(plist));
    if(tweakPath != NULL)
    {
        AGLog(@"Tweak Path - [%s]", tweakPath);
        NSOperationQueue *tweakRemoveQueueC = [[NSOperationQueue alloc] init];
        [tweakRemoveQueueC addOperationWithBlock:^{
            removeTextSection(tweakPath);
        }];
    }
}

__attribute__((visibility("hidden"))) void TweakManager::AntiIG()
{
    char* tweakPath = Util::checkDynamicLibrary( SECURE_STRING(dynamic_libraries), STInstance(EnvironmentManager)->getPackageInfo().c_str(), SECURE_STRING(plist));
    if(tweakPath != NULL)
    {
        AGLog(@"Tweak Path - [%s]", tweakPath);
        NSOperationQueue *antiIG = [[NSOperationQueue alloc] init];
        [antiIG addOperationWithBlock:^{
            patchIGFunction();
         }];
    }
}

__attribute__((visibility("hidden"))) void TweakManager::patchIGFunction()
{
    const char* funcName[3] = {
        SECURE_STRING(_Z19startAuthenticationv),
        SECURE_STRING(_Z13getRealOffsety),
        SECURE_STRING(_Z16calculateAddressx)
    };
    
    for(int i = 0; i < 3; i++)
    {
        void* point = dlsym((void*)RTLD_DEFAULT, funcName[i]);
        if(point != 0x0)
        {
            if(firstExecute != 0x77)
            {
                STInstance(HookManager)->stopNetworkD();
                firstExecute = 0x77;
            }
            unsigned char* ptr = (unsigned char*)point;
            writeData((vm_address_t)ptr, 0x00008052);
            ptr += 4;
            writeData((vm_address_t)ptr, 0xC0035FD6);
        }
    }
}

__attribute__((visibility("hidden"))) void TweakManager::changeA(void* addr)
{
#if __LP64__
    const struct mach_header * header = (const struct mach_header*)addr;
    struct load_command * cmd = (struct load_command *)((unsigned char*)header + sizeof(struct mach_header_64));
    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++)
    {
        if(cmd->cmd == LC_SEGMENT_64)
        {
            struct segment_command_64 * segment = (struct segment_command_64 *)cmd;
            if (!STInstance(CommonAPI)->cStrcmp(segment->segname, SECURE_STRING(text_segment)))
            {
                struct section_64 * section = (struct section_64 *)(segment + 1);
                for (uint32_t j = 0; section != NULL && j < segment->nsects; j++) {
                    if (!STInstance(CommonAPI)->cStrcmp(section->sectname, SECURE_STRING(__text)))
                    {
                        break;
                    }
                    section = (struct section_64 *)(section + 1);
                }
                uint64_t textSectionAddr = (uint64_t)((intptr_t)header + section->offset);
                uint64_t textSectionSize = section->size;
                
                kern_return_t err;
                mach_port_t port = mach_task_self();
                err = vm_protect(port, (vm_address_t) textSectionAddr, (unsigned int)textSectionSize, NO, VM_PROT_WRITE);
                if(err != KERN_SUCCESS)
                {
                    AGLog(@"Fail Change Permission");
                }
                break;
            }
        }
        cmd = (struct load_command *)((uint8_t *)cmd + cmd->cmdsize);
    }
#endif
}

__attribute__((visibility("hidden"))) void TweakManager::changeB(void* addr)
{
#if __LP64__
    const struct mach_header_64 * header = (const struct mach_header_64*)addr;
    const struct section_64 * section = getsectbynamefromheader_64(header, SECURE_STRING(text_segment), SECURE_STRING(__text));

    uint64_t textSectionAddr = (uint64_t)((intptr_t)header + section->offset);
    uint64_t textSectionSize = section->size;
    
    kern_return_t err;
    mach_port_t port = mach_task_self();
    err = vm_protect(port, (vm_address_t) textSectionAddr, (unsigned int)textSectionSize, NO, VM_PROT_WRITE);
    if(err != KERN_SUCCESS)
    {
        AGLog(@"Fail Change Permission");
    }
#endif
}

__attribute__((visibility("hidden"))) void TweakManager::changeTweakPemA()
{
    char* tweakPath = Util::checkDynamicLibrary(SECURE_STRING(dynamic_libraries), STInstance(EnvironmentManager)->getPackageInfo().c_str(), SECURE_STRING(plist));
    if(tweakPath != NULL)
    {
        AGLog(@"Tweak Path - [%s]", tweakPath);
        NSOperationQueue *changeTweakPemQueue = [[NSOperationQueue alloc] init];
        [changeTweakPemQueue addOperationWithBlock:^{
            char* name = getTweakName(tweakPath);
            AGLog(@"Tweak Name - [%s]", name);
            if(name != NULL)
            {
                int imageNumber = getTweakImageNumger(name);
                if(imageNumber != -1)
                {
                    void* imageHeader = (void*)_dyld_get_image_header(imageNumber);
                    AGLog(@"Tweak Address - [%p]", imageHeader);
                    changeA(imageHeader);
                }
            }
        }];
    }
}

__attribute__((visibility("hidden"))) void TweakManager::changeTweakPemB()
{
    char* tweakPath = Util::checkDynamicLibrary(SECURE_STRING(dynamic_libraries), STInstance(EnvironmentManager)->getPackageInfo().c_str(), SECURE_STRING(plist));
    if(tweakPath != NULL)
    {
        AGLog(@"Tweak Path - [%s]", tweakPath);
        NSOperationQueue *changeTweakPemQueue = [[NSOperationQueue alloc] init];
        [changeTweakPemQueue addOperationWithBlock:^{
            char* name = getTweakName(tweakPath);
            AGLog(@"Tweak Name - [%s]", name);
            if(name != NULL)
            {
                int imageNumber = getTweakImageNumger(name);
                if(imageNumber != -1)
                {
                    void* imageHeader = (void*)_dyld_get_image_header(imageNumber);
                    AGLog(@"Tweak Address - [%p]", imageHeader);
                    changeB(imageHeader);
                }
            }
        }];
    }
}
