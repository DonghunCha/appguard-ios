//
//  AGSelfProtectionUtil.inl
//  AppGuard
//
//  Created by NHN on 4/17/25.
//


__inline__ __attribute__((always_inline, visibility("hidden"))) int AGSelfProtectionUtil::getUnityIndex(){
    uint32_t imageCount = _dyld_image_count();
    int unityIndex = -1;
    for(int i=0; i<imageCount; i++)
    {
        const char * name = _dyld_get_image_name(i);
        if(CommonAPI::cStrstr(name, SECURE_STRING(UnityFramework)))
        {
            AGLog(@"Found UnityFramework");
            unityIndex = i;
            return unityIndex;
        }
    }
    return unityIndex;
}

__inline__ __attribute__((always_inline, visibility("hidden"))) void AGSelfProtectionUtil::checkAppGuardCoreFunctionRETPatch() {
    unsigned int methodCount = 0;
    Class cls = [AppGuardCore class];
    if(!cls) {
        return;
    }
    
    std::string patched = "";
    Method *methods = class_copyMethodList(object_getClass(cls), &methodCount);
    if(!methods) {
        return;
    }
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL methodName = method_getName(method);
        std::string methodNameStr(sel_getName(methodName));
        IMP methodImplementation = method_getImplementation(method);
        if(checkRETPatch((void*)methodImplementation)) {
            patched.append(methodNameStr);
            patched.append(";");
        }
    }
    
    if(methods) {
        free(methods);
    }
    
    if(patched.length() > 0) {
        AGLog(@"Diresu patched = %s ", patched.c_str());
        DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupModification, AGPatternNameAppguardModification, AGResponseTypeBlock, patched.c_str());
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block)); //알림창 없이 바로 종료
        STInstance(CommonAPI)->stdSleepFor(2);
        STInstance(ExitManager)->callExit(); // 종료
        makeCrash();
    }
}


// 탐지 알림 없이 종료
__inline__ __attribute__((always_inline, visibility("hidden"))) int AGSelfProtectionUtil::checkAppGuardBinaryPatch() {
    
    bool (SecurityEventHandler::*getForceExitAddress)(void);
    void (ExitManager::*callExitAddress)(void);
    bool result = 0;
    
    getForceExitAddress = &SecurityEventHandler::getForceExit;
    callExitAddress = &ExitManager::callExit;
    
    const char *abusingBytes = "\x31\x02\x40\xF9\x20\x02\x1F\xD6";
    const char PADDING = 8;
    
    unsigned char checkBytesForGetForceExit[CHECK_BYTE_SIZE] = {0,};
    unsigned char checkBytesForCallExit[CHECK_BYTE_SIZE] = {0,};
    
    memcpy(checkBytesForGetForceExit, ((char *)&getForceExitAddress)+PADDING, CHECK_BYTE_SIZE);
    memcpy(checkBytesForCallExit, ((char *)&callExitAddress)+PADDING, CHECK_BYTE_SIZE);
    
    if(memcmp(checkBytesForGetForceExit, abusingBytes, CHECK_BYTE_SIZE) == 0)
    {
        result = 1;
        DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupHooking, AGPatternNameAppGuardHook, AGResponseTypeBlock, SECURE_STRING(checkAppGuardBinaryPatch1));
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        STInstance(CommonAPI)->stdSleepFor(2);
        STInstance(ExitManager)->callExit(); // 종료
        makeCrash();
    }
    if(memcmp(checkBytesForCallExit, abusingBytes, CHECK_BYTE_SIZE) == 0)
    {
        result = 1;
        DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupHooking, AGPatternNameAppGuardHook, AGResponseTypeBlock, SECURE_STRING(checkAppGuardBinaryPatch2));
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        STInstance(CommonAPI)->stdSleepFor(2);
        STInstance(ExitManager)->callExit(); // 종료
        makeCrash();
    }
    return result;
}

__inline__ __attribute__((always_inline, visibility("hidden"))) bool AGSelfProtectionUtil::checkExportedFunctionRETPatch() {
    const int kExportedFunctionCount = 15;
    char patched[kExportedFunctionCount] = {'\0'};
    bool result = false;
    void* functionList[kExportedFunctionCount] = {
        (void*)a,
        (void*)b,
        (void*)k,
        (void*)c,
        (void*)d,
        (void*)h,
        (void*)i,
        (void*)e,
        (void*)g,
        (void*)z,
        (void*)cs,
        (void*)cc,
        (void*)checkSwizzled,
        (void*)checkCodeHashByAppGuard,
        nullptr
    };
    int i = 0 ;
    
    while(functionList[i] != nullptr) {
        patched[i] = checkRETPatch(functionList[i]) ? '1' : '0';
        if( patched[i] == '1' ) {
            result = true;
        }
        i++;
    }
    
    AGLog(@"Exported function RET Patch check = %s.", patched);
    STInstance(CommonAPI)->stdSleepFor(3);
    if(result) {
        std::string detail = std::string(SECURE_STRING(status_monitor_detail_msg_exported_function_patched)) + std::string(patched);
        DetectInfo* detectInfo = new DetectInfo(1915, AGPatternGroupModification, AGPatternNameAppguardModification, AGResponseTypeBlock, detail.c_str());
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        STInstance(CommonAPI)->stdSleepFor(2);
        STInstance(ExitManager)->callExit(); // 종료
        STInstance(CommonAPI)->stdSleepFor(5);
        makeCrash();
        return true;
    }
    return false;
}


//탐지 알림 없이 바로 종료합니다.
__inline__ __attribute__((always_inline, visibility("hidden"))) int AGSelfProtectionUtil::checkSwizzledForUnity(uint64_t functionAddr ,int imageIndex) {
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
                        
                        uint64_t __text_size = section->size;
                        uint64_t __text_addr = (uint64_t)((uint64_t)header + section->addr - segment->vmaddr);
                        uint64_t __text_range = __text_addr + __text_size;
                        
                        AGLog(@"__text_size  : %08llx", __text_size);
                        AGLog(@"__text_addr  : %08llx", __text_addr);
                        AGLog(@"__text_range : %08llx", __text_range);
                        AGLog(@"functionAddr : %08llx", functionAddr);
                        
                        
                        if(__text_addr < functionAddr && functionAddr < __text_range){
                            AGLog(@"NO Hooking Diresu");
                            return 0;
                        }else{
                            AGLog(@"Hooking Diresu!!");
                            DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupHooking, AGPatternNameAppGuardHook, AGResponseTypeBlock, SECURE_STRING(Diresu));
                            STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
                            STInstance(CommonAPI)->stdSleepFor(2);
                            STInstance(ExitManager)->callExit(); // 종료
                            makeCrash();
                            return -1;
                        }
                    }
                    section = section + 1;
                }
                
            } else if(CommonAPI::cStrstr(segment->segname, SECURE_STRING(zTEXT))) {
                DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupHooking, AGPatternNameObjcAPIHook, AGResponseTypeBlock, SECURE_STRING(zTEXT));
                STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
                STInstance(CommonAPI)->stdSleepFor(2);
                STInstance(ExitManager)->callExit(); // 종료
                makeCrash();
                
            } else if(CommonAPI::cStrstr(segment->segname, SECURE_STRING(zDATA))) {
                DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupHooking, AGPatternNameObjcAPIHook, AGResponseTypeBlock, SECURE_STRING(zDATA));
                STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
                STInstance(CommonAPI)->stdSleepFor(2);
                STInstance(ExitManager)->callExit(); // 종료
                makeCrash();
            }
        }
        lc_cmd = (struct  load_command*)((uint8_t*)lc_cmd + segment->cmdsize);
    }
    return 0;
}
// 탐지 알람 없이 바로 종료합니다.
__inline__ __attribute__((always_inline, visibility("hidden"))) int AGSelfProtectionUtil::checkSwizzledForApp(uint64_t functionAddr) {
    char * __TEXT = SECURE_STRING(text_segment);
    char * __text = SECURE_STRING(__text);
    
    struct section_64 *pSEC = (struct section_64 *)getsectbyname(__TEXT, __text);
    intptr_t image_slide;
    
    int imageIndex = Util::getImageNumber();
    
    image_slide = _dyld_get_image_vmaddr_slide(imageIndex);
    
    //    uint64_t functionAddr = (uint64_t)functionPointer;
    uint64_t __text_addr = pSEC->addr + (uint64_t)image_slide;;
    AGLog(@"__text_addr : %08llx", __text_addr);
    uint64_t __text_size = pSEC->size;
    AGLog(@"__text_size : %08llx", __text_size);
    uint64_t __text_range = __text_addr + __text_size;
    AGLog(@"__text_range : %08llx", __text_range);
    AGLog(@"functionAddr : %08llx", functionAddr);
    
    if(__text_addr < functionAddr && functionAddr < __text_range){
        AGLog(@"NO Hooking Diresu");
        return 0;
    }else{
        AGLog(@"Hooking Diresu!!");
        
        NSString* imageName = @"";
        Dl_info info;
        if (dladdr((void*)functionAddr, &info)) {
            imageName = [[NSString stringWithFormat:@"%s", info.dli_fname] lastPathComponent];
        }
        
        NSString* detail = [NSString stringWithFormat:@"%@ in %@", NS_SECURE_STRING(Diresu), imageName];
        
        DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupHooking, AGPatternNameAppGuardHook, AGResponseTypeBlock, [detail cStringUsingEncoding:NSUTF8StringEncoding]);
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        STInstance(CommonAPI)->stdSleepFor(2);
        STInstance(ExitManager)->callExit(); // 종료
        makeCrash();
        return -1;
    }
}


__inline__ __attribute__((always_inline, visibility("hidden"))) int AGSelfProtectionUtil::checkTextSectionHashByProtector() {
    NSOperationQueue *textSectionCheckQueue = [[NSOperationQueue alloc] init];
    [textSectionCheckQueue addOperationWithBlock:^{
        if(STInstance(IntegrityManager)->checkTextSectionHashByProtector() ||
           STInstance(IntegrityManager)->checkUnityFramework()) {
            DetectInfo* detectInfo = new DetectInfo(1401, AGPatternGroupModification, AGPatternNameCodeModification, AGResponseTypeBlock, SECURE_STRING(check_text_section_by_check_code));
            STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
            STInstance(CommonAPI)->stdSleepFor(2);
            STInstance(ExitManager)->callExit(); // 종료
            makeCrash();
        } else {
            AGLog(@"checkTextSectionHashByProtector fail.");
        }
    }];
    return 0;
}


//유니티 인터페이스 RET패치 확인
__inline__ __attribute__((always_inline, visibility("hidden"))) int AGSelfProtectionUtil::checkUnityInterface() {

    if(checkRETPatch((void*)d)) {
        AGLog(@"UnityInterface d() RET Patched.");
        DetectInfo* detectInfo = new DetectInfo(1602, AGPatternGroupModification, AGPatternNameAppguardModification, AGResponseTypeBlock, SECURE_STRING(unity_interface_patched));
        STInstance(LogNCrash)->sendLog(kDetectLog, detectInfo, SECURE_STRING(block));
        STInstance(CommonAPI)->stdSleepFor(2);
        STInstance(ExitManager)->callExit(); // 종료
        makeCrash();
        return -1;
    }

    return 0;
}

__inline__ __attribute__((always_inline, visibility("hidden"))) bool AGSelfProtectionUtil::checkIsDebugDylibFunction(void* functionAddr)
{
    Dl_info info;
    if (!dladdr(functionAddr, &info)) {
        return false;
    }
    
    AGLog(@"Symbol: %s, Image: %s", info.dli_sname, info.dli_fname);
    NSString* dliFileName = [NSString stringWithFormat:@"%s", info.dli_fname];
    
    // check NAME.debug.dylib
    // https://developer.apple.com/documentation/xcode/build-settings-reference#Enable-Debug-Dylib-Support
    if ([dliFileName.lowercaseString containsString:NS_SECURE_STRING(debug_dylib).lowercaseString]) {
        AGLog(@"function in debug.dylib");
        return true;
    }
    return false;
}
