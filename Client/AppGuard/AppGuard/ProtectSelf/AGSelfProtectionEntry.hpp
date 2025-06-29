//
//  AGSelfProtectionEntry.hpp
//  AppGuard
//
//  Created by NHN on 4/17/25.
//

#ifndef AGSelfProtectionEntry_hpp
#define AGSelfProtectionEntry_hpp

#include "AGSelfProtectionUtil.hpp"
#include <dispatch/dispatch.h>

__attribute__((constructor, used, visibility("hidden"))) void SelfProtectionEntry() {
    @autoreleasepool{
        static dispatch_queue_t selfprotectQueue;
        static dispatch_source_t selfprotectTimer;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            @autoreleasepool{
                dispatch_async(dispatch_queue_create(NULL, NULL), ^{
                    @autoreleasepool{
                        selfprotectQueue = dispatch_queue_create(NULL, NULL);
                        selfprotectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, selfprotectQueue);
                        if (selfprotectTimer) {
                            dispatch_source_set_timer(selfprotectTimer,
                                                      dispatch_time(DISPATCH_TIME_NOW, 40 * NSEC_PER_SEC),
                                                      33 * NSEC_PER_SEC, // 33초 간격
                                                      5 * NSEC_PER_SEC); // 5초 오차
                            
                            dispatch_source_set_event_handler(selfprotectTimer, ^{
                                @autoreleasepool{
                                    AGLog(@"[+] SelfProtectionEntry...");
                                    AGSelfProtectionUtil::checkAppGuardBinaryPatch();
                                    // Diresu s RET패치 확인
                                    AGSelfProtectionUtil::checkAppGuardCoreFunctionRETPatch();
                                    //export 인터페이스 RET패치 확인
                                    AGSelfProtectionUtil::checkExportedFunctionRETPatch();
                                    
                                    IMP methodIMP = [AppGuardCore methodForSelector:@selector(doAppGuard::::)];
                                    void (*appguardCoreFuncPtr)(id, SEL) = (void (*)(id, SEL))methodIMP;
                                    AGLog(@"functionPointer %p", appguardCoreFuncPtr);
                                    
                                    // ENABLE_DEBUG_DYLIB 활성화 될 경우 NAME.debug.dylib에 위치
                                    if(AGSelfProtectionUtil::checkIsDebugDylibFunction((void*)appguardCoreFuncPtr))
                                    {
                                        return;
                                    }
                                    
                                    int unityIndex = AGSelfProtectionUtil::getUnityIndex();
                                    if( unityIndex != -1 ) {
                                        AGLog(@"It is unity");
                                        AGSelfProtectionUtil::checkSwizzledForUnity((uint64_t)appguardCoreFuncPtr, unityIndex);
                                    } else {
                                        AGLog(@"It is not unity");
                                        AGSelfProtectionUtil::checkSwizzledForApp((uint64_t)appguardCoreFuncPtr);
                                    }
                                }
                            });
                            dispatch_resume(selfprotectTimer);
                        }
                    }
                });
            }
        });
    }
}


#endif /* AGSelfProtectionEntry_hpp */
