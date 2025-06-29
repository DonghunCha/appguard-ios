//
//  HookManager.cpp
//  AppGuard
//
//  Created by NHNEnt on 30/01/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#include "HookManager.hpp"

__attribute__((visibility("hidden"))) char* HookManager::checkAppGuardAPIHook()
{
    char* result = nullptr;
    @try
    {
        char* objc[AG_CLASS_NUM] = {
            SECURE_STRING(Diresu),
            SECURE_STRING(ToastMemoryInformationManager),
            SECURE_STRING(AGNController)
        };
       
        for(int i = 0; i < AG_CLASS_NUM; i++)
        {
            const char* objcClass = objc[i];
            Class cls = objc_getClass(objcClass);
            if(cls)
            {
                unsigned int methodCount = 0;
                Method* methods = class_copyMethodList(cls, &methodCount);
                if(methodCount == 0)
                {
                    cls = object_getClass(cls);
                    if(cls)
                    {
                        methods = class_copyMethodList(cls, &methodCount);
                    }
                }
                
                if(methods != NULL && methodCount != 0)
                {
                    for(unsigned int j = 0; j < methodCount; j++)
                    {
                        Method method = methods[j];
                        if(method)
                        {
                            const char* selName = sel_getName(method_getName(method));
                            if(selName != NULL)
                            {
                                SEL sel = method_getName(method);
                                if(sel)
                                {
                                    void* addr = (void*)class_getMethodImplementation(cls, sel);
                                    Dl_info info = {0,};
                                    if(dladdr(addr, &info))
                                    {
                                        if(STInstance(CommonAPI)->cStrstr(info.dli_fname, SECURE_STRING(dynamic_libraries)) != NULL )
                                        {
                                            AGLog(@"class - [%s] method - [%s] hook lib - [%s]", objcClass, selName, info.dli_fname);
                                            result = (char*)info.dli_fname;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if(methods) {
                    free(methods);
                }
            }
        }
    }@catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) char* HookManager::checkObjCAPIHook()
{
    char* result = nullptr;
    @try
    {
        char* objc[OBJC_CLASS_NUM] = {
            SECURE_STRING(uiapplication),
            SECURE_STRING(nsstring),
            SECURE_STRING(nsfilemanager)
        };
        
        for(int i = 0; i < OBJC_CLASS_NUM; i++)
        {
            const char* objcClass = objc[i];
            Class cls = objc_getClass(objcClass);
            if(cls)
            {
                unsigned int methodCount = 0;
                Method* methods = class_copyMethodList(cls, &methodCount);
                if(methods)
                {
                    for(unsigned int j = 0; j < methodCount; j++)
                    {
                        Method method = methods[j];
                        if(method)
                        {
                            const char* selName = sel_getName(method_getName(method));
                            if(selName != NULL)
                            {
                                SEL sel = method_getName(method);
                                if(sel)
                                {
                                    void* addr = (void*)class_getMethodImplementation(cls, sel);
                                    Dl_info info = {0,};
                                    if(dladdr(addr, &info))
                                    {
                                        if(STInstance(CommonAPI)->cStrstr(info.dli_fname, SECURE_STRING(dynamic_libraries)) != NULL )
                                        {
                                            AGLog(@"class - [%s] method - [%s] hook lib - [%s]", objcClass, selName, info.dli_fname);
                                            result = (char*)info.dli_fname;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if(methods) {
                    free(methods);
                }
            }
        }
    }@catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    return result;
}

__attribute__((visibility("hidden"))) void HookManager::checkUserMethodHook(const char* className, const char* methodName)
{
    @try
    {
        Class cls = objc_getClass(className);
        if(cls)
        {
            unsigned int methodCount = 0;
            Method* methods = class_copyMethodList(cls, &methodCount);
            if(methodCount == 0)
            {
                cls = object_getClass(cls);
                if(cls)
                {
                    methods = class_copyMethodList(cls, &methodCount);
                }
            }
            
            if(methods != NULL && methodCount != 0)
            {
                for(unsigned int i = 0; i < methodCount; i++)
                {
                    Method method = methods[i];
                    if(method)
                    {
                        const char* selName = sel_getName(method_getName(method));
                        if(selName != NULL)
                        {
                            if(STInstance(CommonAPI)->cStrcmp(selName, methodName) == 0 )
                            {
                                SEL sel = method_getName(method);
                                if(sel)
                                {
                                    void* addr = (void*)class_getMethodImplementation(cls, sel);
                                    Dl_info info = {0,};
                                    if(dladdr(addr, &info))
                                    {
                                        if(STInstance(CommonAPI)->cStrstr(info.dli_fname, SECURE_STRING(dynamic_libraries)) != NULL )
                                        {
                                            AGLog(@"class - [%s] method - [%s] hook lib - [%s]", className, selName, info.dli_fname);
                                            DetectInfo* detectInfo = new DetectInfo(1603, AGPatternGroupHooking, AGPatternNameUserFuntionHook, STInstance(PatternManager)->getResponseTypeOfHook(), info.dli_fname);
                                            STInstance(ResponseManager)->doResponseImmediately(detectInfo);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if(methods) {
                free(methods);
            }
        }
    }
    @catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
}

__attribute__((visibility("hidden"))) char* HookManager::checkSystemAPIHook()
{
    NSString* result = @"H";
    @try
    {
        for(int i = 0; i < API_NUM; i++)
        {
            if(checkAPIByte(api[i]))
            {
                result = [result stringByAppendingFormat:@"%d", i];
            }
        }
    }@catch(NSException *exception)
    {
        AGLog(@"Exception name : [%@], reason : [%@]", [exception name], [exception reason]);
    }
    
    AGLog(@"result - [%@]", result);
    return (char*)NS2CString(result);
}

__attribute__((visibility("hidden"))) char* HookManager::checkValidSvcCallHook()
{
    
    NSString* result = @"SH";
#if defined __arm64__ || defined __arm64e__
    for(int i = 0 ; i < VALID_SVC_CALL_NUM; i++)
    {
        uint8_t* svcCallOffset = (uint8_t*)kValidSvcCall[i].funcAddr + kValidSvcCall[i].signatureOffset;
        if(memcmp(svcCallOffset, kValidSvcCall[i].vaildSignature, kValidSvcCall[i].signitureSize) != 0)
        {
            result = [result stringByAppendingFormat:@"%d", i];
        }
    }
    AGLog(@"result - [%@]", result);
#else
    AGLog(@"Passing in a non-Arm64 environment.");
#endif
    return (char*)NS2CString(result);
}

__attribute__((visibility("hidden"))) bool HookManager::checkAPIByte(void* funcAddr)
{
    bool result = false;
#if __LP64__
    if(funcAddr != nullptr)
    {
        unsigned char checkByte[CHECK_BYTE_SIZE] = {0,};
        memcpy(checkByte, funcAddr, CHECK_BYTE_SIZE);
        if(memcmp(checkByte, checkByte_, CHECK_BYTE_SIZE) == 0)
        {
            AGLog(@"func addr - [%p] check byte - [%s] memory byte - [%s]", funcAddr, checkByte_, checkByte);
            result = true;
        }
    }
#else
    AGLog(@"Pass 32bit Device");
#endif
    return result;
}

__attribute__((visibility("hidden"))) void HookManager::swizzlingAppGuardAPIA()
{
    Class cls = objc_getClass(SECURE_STRING(Diresu));
    if(cls)
    {
        cls = object_getClass(cls);
        if(cls)
        {
            unsigned int methodCount = 0;
            Method* methods = class_copyMethodList(cls, &methodCount);
            for(unsigned int i = 0; i < methodCount; i++)
            {
                Method method = methods[i];
                if(method)
                {
                    const char* selName = sel_getName(method_getName(method));
                    if(selName != NULL)
                    {
                        SEL sel = method_getName(method);
                        if(sel)
                        {
                            void* addr = (void*)class_getMethodImplementation(cls, sel);
                            Dl_info info = {0,};
                            if(dladdr(addr, &info))
                            {
                                if(STInstance(CommonAPI)->cStrstr(info.dli_fname, SECURE_STRING(dynamic_libraries)) != NULL )
                                {
                                    Method changeMethod = NULL;
                                    if(STInstance(CommonAPI)->cStrcmp(selName, SECURE_STRING(s____)) == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(initWithOperations____));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, "o::") == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(addData__));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, "v::") == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(removeData__));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, "w:") == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(setResponseQueue_));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, "n:") == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(randomDataOfLength_));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, "e:") == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(initWithHandler_));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, "k") == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(error));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, "t") == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(read));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, "z") == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(write));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                    else if(STInstance(CommonAPI)->cStrcmp(selName, SECURE_STRING(free)) == 0)
                                    {
                                        changeMethod = getAGMethod(SECURE_STRING(finish));
                                        if(changeMethod != NULL)
                                        {
                                            method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(methods) {
                free(methods);
            }
        }
    }
}

__attribute__((visibility("hidden"))) void HookManager::swizzlingAppGuardAPIB()
{
    if(STInstance(JailbreakManager)->checkABypass() != false)
    {
        Class cls = objc_getClass(SECURE_STRING(Diresu));
        if(cls)
        {
            cls = object_getClass(cls);
            if(cls)
            {
                unsigned int methodCount = 0;
                Method* methods = class_copyMethodList(cls, &methodCount);
                for(unsigned int i = 0; i < methodCount; i++)
                {
                    Method method = methods[i];
                    if(method)
                    {
                        const char* selName = sel_getName(method_getName(method));
                        if(selName != NULL)
                        {
                            SEL sel = method_getName(method);
                            if(sel)
                            {
                                Method changeMethod = NULL;
                                if(STInstance(CommonAPI)->cStrcmp(selName, SECURE_STRING(s____)) == 0)
                                {
                                    changeMethod = getAGMethod(SECURE_STRING(initWithOperations____));
                                    if(changeMethod != NULL)
                                    {
                                        method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                    }
                                }
                                else if(STInstance(CommonAPI)->cStrcmp(selName, "o::") == 0)
                                {
                                    changeMethod = getAGMethod(SECURE_STRING(addData__));
                                    if(changeMethod != NULL)
                                    {
                                        method_exchangeImplementations(class_getInstanceMethod(cls, sel), changeMethod);
                                    }
                                }
                            }
                        }
                    }
                }
                if(methods) {
                    free(methods);
                }
            }
        }
    }
}

__attribute__((visibility("hidden"))) Method HookManager::getAGMethod(const char* methodName)
{
    Method result = NULL;
    Class cls = objc_getClass(SECURE_STRING(RNCryptorLoader));
    if(cls)
    {
        unsigned int methodCount = 0;
        Method* methods = class_copyMethodList(cls, &methodCount);
        if(methods != NULL && methodCount != 0)
        {
            for(unsigned int i = 0; i < methodCount; i++)
            {
                Method method = methods[i];
                if(method)
                {
                    const char* selName = sel_getName(method_getName(method));
                    if(selName != NULL)
                    {
                        if(STInstance(CommonAPI)->cStrcmp(selName, methodName) == 0)
                        {
                            SEL sel = method_getName(method);
                            if(sel)
                            {
                                result = class_getInstanceMethod(cls, sel);
                                break;
                            }
                        }
                    }
                }
            }
        }
        if(methods) {
            free(methods);
        }
    }
    return result;
}

// fish hook //
__attribute__((visibility("hidden"))) void HookManager::stopNetworkA()
{
    if(STInstance(JailbreakManager)->checkDyld(SECURE_STRING(dynamic_libraries)) != false)
    {
        NSOperationQueue *networkStopQueueA = [[NSOperationQueue alloc] init];
        [networkStopQueueA addOperationWithBlock:^{
            rebind_symbols((struct rebinding[6]){
                                {SECURE_STRING(send),     (void*)mySend,     (void **)&orgS},
                                {SECURE_STRING(sendto),   (void*)mySendto,   (void **)&orgSt},
                                {SECURE_STRING(sendmsg),  (void*)mySendmsg,  (void **)&orgSm},
                                {SECURE_STRING(recv),     (void*)myRecv,     (void **)&orgR},
                                {SECURE_STRING(recvfrom), (void*)myRecvfrom, (void **)&orgRf},
                                {SECURE_STRING(recvmsg),  (void*)myRecvmsg,  (void **)&orgRm}
                            }, 6);
        }];
    }
}

__attribute__((visibility("hidden"))) int HookManager::prepend_rebindings(struct rebindings_entry **rebindings_head, struct rebinding rebindings[], size_t nel)
{
    struct rebindings_entry *new_entry = (struct rebindings_entry *) malloc(sizeof(struct rebindings_entry));
    if (!new_entry)
    {
        return -1;
    }
    new_entry->rebindings = (struct rebinding *) malloc(sizeof(struct rebinding) * nel);
    if(!new_entry->rebindings)
    {
        free(new_entry);
        return -1;
    }
    memcpy(new_entry->rebindings, rebindings, sizeof(struct rebinding) * nel);
    new_entry->rebindings_nel = nel;
    new_entry->next = *rebindings_head;
    *rebindings_head = new_entry;
    return 0;
}

__attribute__((visibility("hidden"))) void HookManager::perform_rebinding_with_section(
                                                                                       struct rebindings_entry *rebindings,
                                                                                       section_t *section,
                                                                                       intptr_t slide,
                                                                                       nlist_t *symtab,
                                                                                       char *strtab,
                                                                                       uint32_t *indirect_symtab) {
    
    uint32_t *indirect_symbol_indices = indirect_symtab + section->reserved1;
    void **indirect_symbol_bindings = (void **)((uintptr_t)slide + section->addr);
    
    for (uint i = 0; i < section->size / sizeof(void *); i++) {
        
        uint32_t symtab_index = indirect_symbol_indices[i];
        if (symtab_index == INDIRECT_SYMBOL_ABS ||
            symtab_index == INDIRECT_SYMBOL_LOCAL ||
            symtab_index == (INDIRECT_SYMBOL_LOCAL|INDIRECT_SYMBOL_ABS)) {
            continue;
        }
        
        uint32_t strtab_offset = symtab[symtab_index].n_un.n_strx;
        char *symbol_name = strtab + strtab_offset;
        bool symbol_name_longer_than_1 = symbol_name[0] && symbol_name[1];
        struct rebindings_entry *cur = rebindings;
        
        while (cur) {
            for (uint j = 0; j < cur->rebindings_nel; j++) {
                
                if (symbol_name_longer_than_1 && STInstance(CommonAPI)->cStrcmp(&symbol_name[1], cur->rebindings[j].name) == 0) {
                    
                    kern_return_t err;
                    
                    if (cur->rebindings[j].replaced != NULL && indirect_symbol_bindings[i] != cur->rebindings[j].replacement) {
                        *(cur->rebindings[j].replaced) = indirect_symbol_bindings[i];
                    }
                    
                    err = vm_protect (mach_task_self (), (uintptr_t)indirect_symbol_bindings, section->size, 0, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
                   
                    if (err == KERN_SUCCESS) {
                        indirect_symbol_bindings[i] = cur->rebindings[j].replacement;
                        AGLog(@"replace : %s - %s",&symbol_name[1], cur->rebindings[j].name);
                    } else {
                        AGLog(@"not replace : %s - %s",&symbol_name[1], cur->rebindings[j].name);
                    }
                    goto symbol_loop;
                }
            }
            cur = cur->next;
        }
        symbol_loop:;
    }
}

__attribute__((visibility("hidden"))) void HookManager::rebind_symbols_for_image(struct rebindings_entry *rebindings, const struct mach_header *header, intptr_t slide)
{
    Dl_info info;
    if (dladdr(header, &info) == 0)
    {
        return;
    }

    segment_command_t *cur_seg_cmd;
    segment_command_t *linkedit_segment = NULL;
    struct symtab_command* symtab_cmd = NULL;
    struct dysymtab_command* dysymtab_cmd = NULL;

    uintptr_t cur = (uintptr_t)header + sizeof(mach_header_t);
    for (uint i = 0; i < header->ncmds; i++, cur += cur_seg_cmd->cmdsize)
    {
        cur_seg_cmd = (segment_command_t *)cur;
        if(cur_seg_cmd->cmd == LC_SEGMENT_ARCH_DEPENDENT)
        {
            if(STInstance(CommonAPI)->cStrcmp(cur_seg_cmd->segname, SEG_LINKEDIT) == 0)
            {
                linkedit_segment = cur_seg_cmd;
            }
        }else if(cur_seg_cmd->cmd == LC_SYMTAB)
        {
            symtab_cmd = (struct symtab_command*)cur_seg_cmd;
        }else if(cur_seg_cmd->cmd == LC_DYSYMTAB)
        {
            dysymtab_cmd = (struct dysymtab_command*)cur_seg_cmd;
        }
    }
    if(!symtab_cmd || !dysymtab_cmd || !linkedit_segment || !dysymtab_cmd->nindirectsyms)
    {
        return;
    }

    // Find base symbol/string table addresses
    uintptr_t linkedit_base = (uintptr_t)slide + linkedit_segment->vmaddr - linkedit_segment->fileoff;
    nlist_t *symtab = (nlist_t *)(linkedit_base + symtab_cmd->symoff);
    char *strtab = (char *)(linkedit_base + symtab_cmd->stroff);

    // Get indirect symbol table (array of uint32_t indices into symbol table)
    uint32_t *indirect_symtab = (uint32_t *)(linkedit_base + dysymtab_cmd->indirectsymoff);

    cur = (uintptr_t)header + sizeof(mach_header_t);
    for (uint i = 0; i < header->ncmds; i++, cur += cur_seg_cmd->cmdsize)
    {
        cur_seg_cmd = (segment_command_t *)cur;
        if(cur_seg_cmd->cmd == LC_SEGMENT_ARCH_DEPENDENT)
        {
            if(STInstance(CommonAPI)->cStrcmp(cur_seg_cmd->segname, SEG_DATA) != 0 && STInstance(CommonAPI)->cStrcmp(cur_seg_cmd->segname, SEG_DATA_CONST) != 0)
            {
                continue;
            }
            for(uint j = 0; j < cur_seg_cmd->nsects; j++)
            {
                section_t *sect = (section_t *)(cur + sizeof(segment_command_t)) + j;
                if((sect->flags & SECTION_TYPE) == S_LAZY_SYMBOL_POINTERS)
                {
                    perform_rebinding_with_section(rebindings, sect, slide, symtab, strtab, indirect_symtab);
                }
                if((sect->flags & SECTION_TYPE) == S_NON_LAZY_SYMBOL_POINTERS)
                {
                    perform_rebinding_with_section(rebindings, sect, slide, symtab, strtab, indirect_symtab);
                }
            }
        }
    }
}

__attribute__((visibility("hidden"))) void HookManager::stopNetworkB()
{
    if(STInstance(JailbreakManager)->checkDyld(SECURE_STRING(dynamic_libraries)) != false)
    {
        NSOperationQueue *networkStopQueueB = [[NSOperationQueue alloc] init];
        [networkStopQueueB addOperationWithBlock:^{
            rebind_symbols((struct rebinding[6]){
                                {SECURE_STRING(send),     (void*)mySend,     (void **)&orgS},
                                {SECURE_STRING(sendto),   (void*)mySendto,   (void **)&orgSt},
                                {SECURE_STRING(sendmsg),  (void*)mySendmsg,  (void **)&orgSm},
                                {SECURE_STRING(recv),     (void*)myRecv,     (void **)&orgR},
                                {SECURE_STRING(recvfrom), (void*)myRecvfrom, (void **)&orgRf},
                                {SECURE_STRING(recvmsg),  (void*)myRecvmsg,  (void **)&orgRm}
                            }, 6);
        }];
    }
}

__attribute__((visibility("hidden"))) void HookManager::_rebind_symbols_for_image(const struct mach_header *header, intptr_t slide)
{
    rebind_symbols_for_image(_rebindings_head, header, slide);
}

__attribute__((visibility("hidden"))) int HookManager::rebind_symbols_image(void *header, intptr_t slide, struct rebinding rebindings[], size_t rebindings_nel)
{
    struct rebindings_entry *rebindings_head = NULL;
    int retval = prepend_rebindings(&rebindings_head, rebindings, rebindings_nel);
    rebind_symbols_for_image(rebindings_head, (const struct mach_header *) header, slide);
    if(rebindings_head)
    {
      free(rebindings_head->rebindings);
    }
    free(rebindings_head);
    return retval;
}

__attribute__((visibility("hidden"))) int HookManager::rebind_symbols(struct rebinding rebindings[], size_t rebindings_nel) {
    int retval = prepend_rebindings(&_rebindings_head, rebindings, rebindings_nel);
    AGLog(@"retval - [%d]", retval);
    if(retval < 0) {
        AGLog(@"Fail prepend rebindings");
        return retval;
    }
    // If this was the first call, register callback for image additions (which is also invoked for
    // existing images, otherwise, just run on existing images
    if (!_rebindings_head->next) {
        _dyld_register_func_for_add_image(_rebind_symbols_for_image);
    } else {
        uint32_t c = _dyld_image_count();
        for (uint32_t i = 0; i < c; i++) {
          _rebind_symbols_for_image(_dyld_get_image_header(i), _dyld_get_image_vmaddr_slide(i));
        }
    }
    AGLog(@"result value - [%d]", retval);
    return retval;
}

__attribute__((visibility("hidden"))) ssize_t HookManager::mySend(int sockfd, const void *buf, size_t len, int flags)
{
    return 0;
}
__attribute__((visibility("hidden"))) ssize_t HookManager::mySendto(int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *dest_addr, socklen_t addrlen)
{
    return 0;
}
__attribute__((visibility("hidden"))) ssize_t HookManager::mySendmsg(int sockfd, const struct msghdr *msg, int flags)
{
    return 0;
}
__attribute__((visibility("hidden"))) ssize_t HookManager::myRecv(int sockfd, void *buf, size_t len, int flags)
{
    return 0;
}
__attribute__((visibility("hidden"))) ssize_t HookManager::myRecvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *src_addr, socklen_t *addrlen)
{
    return 0;
}
__attribute__((visibility("hidden"))) ssize_t HookManager::myRecvmsg(int sockfd, struct msghdr *msg, int flags)
{
    return 0;
}

__attribute__((visibility("hidden"))) void HookManager::stopNetworkC()
{
    if(STInstance(JailbreakManager)->checkDyld(SECURE_STRING(dynamic_libraries)) != false)
    {
        NSOperationQueue *networkStopQueueC = [[NSOperationQueue alloc] init];
        [networkStopQueueC addOperationWithBlock:^{
            rebind_symbols((struct rebinding[6]){
                                {SECURE_STRING(send),     (void*)mySend,     (void **)&orgS},
                                {SECURE_STRING(sendto),   (void*)mySendto,   (void **)&orgSt},
                                {SECURE_STRING(sendmsg),  (void*)mySendmsg,  (void **)&orgSm},
                                {SECURE_STRING(recv),     (void*)myRecv,     (void **)&orgR},
                                {SECURE_STRING(recvfrom), (void*)myRecvfrom, (void **)&orgRf},
                                {SECURE_STRING(recvmsg),  (void*)myRecvmsg,  (void **)&orgRm}
                            }, 6);
        }];
    }
}

__attribute__((visibility("hidden"))) void HookManager::stopNetworkD()
{
    NSOperationQueue *networkStopQueueD = [[NSOperationQueue alloc] init];
    [networkStopQueueD addOperationWithBlock:^{
        rebind_symbols((struct rebinding[6]){
                            {SECURE_STRING(send),     (void*)mySend,     (void **)&orgS},
                            {SECURE_STRING(sendto),   (void*)mySendto,   (void **)&orgSt},
                            {SECURE_STRING(sendmsg),  (void*)mySendmsg,  (void **)&orgSm},
                            {SECURE_STRING(recv),     (void*)myRecv,     (void **)&orgR},
                            {SECURE_STRING(recvfrom), (void*)myRecvfrom, (void **)&orgRf},
                            {SECURE_STRING(recvmsg),  (void*)myRecvmsg,  (void **)&orgRm}
                        }, 6);
    }];
}
