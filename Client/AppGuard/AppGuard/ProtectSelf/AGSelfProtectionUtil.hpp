//
//  AGSelfProtectionUtil.hpp
//  AppGuard
//
//  Created by NHN on 4/17/25.
//

#ifndef AGSelfProtectionUtil_hpp
#define AGSelfProtectionUtil_hpp


#import "Diresu.h"
#include "UnityInterface.hpp"
#include "LogNCrash.h"
#include "AppGuardChecker.hpp"
#include "Log.h"
#include "Pattern.h"
#include "SVCManager.hpp"
#include "HookManager.hpp"
#include "DebugManager.hpp"
#include "PolicyManager.hpp"
#include "DetectManager.hpp"
#include "PatternManager.hpp"
#include "ResponseManager.hpp"

#include <Foundation/Foundation.h>
#include <dispatch/dispatch.h>

namespace AGSelfProtectionUtil {
    __inline__ __attribute__((always_inline, visibility("hidden"))) int getUnityIndex();
    __inline__ __attribute__((always_inline, visibility("hidden"))) static void checkAppGuardCoreFunctionRETPatch();
    __inline__ __attribute__((always_inline, visibility("hidden"))) int checkAppGuardBinaryPatch();
    __inline__ __attribute__((always_inline, visibility("hidden"))) bool checkExportedFunctionRETPatch();
    __inline__ __attribute__((always_inline, visibility("hidden"))) int checkSwizzledForUnity(uint64_t functionAddr ,int imageIndex);
    __inline__ __attribute__((always_inline, visibility("hidden"))) int checkSwizzledForApp(uint64_t functionAddr);
    __inline__ __attribute__((always_inline, visibility("hidden"))) int checkTextSectionHashByProtector();
    __inline__ __attribute__((always_inline, visibility("hidden"))) int checkUnityInterface();
    __inline__ __attribute__((always_inline, visibility("hidden"))) bool checkIsDebugDylibFunction(void* functionAddr);
}

#include "AGSelfProtectionUtil.inl"


#endif /* AGSelfProtectionUtil_hpp */
