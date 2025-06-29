//
//  HookManager.hpp
//  AppGuard
//
//  Created by NHNEnt on 30/01/2020.
//  Copyright © 2020 nhnent. All rights reserved.
//

#ifndef HookManager_hpp
#define HookManager_hpp

#import <Foundation/Foundation.h>

#include <stdio.h>
#include <regex.h>
#include <dlfcn.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <mach/mach.h>
#include <sys/sysctl.h>
#include <mach-o/dyld.h>
#include <mach/vm_map.h>
#include <mach-o/nlist.h>
#include <objc/runtime.h>
#include <mach-o/loader.h>
#include <mach/vm_region.h>

#include "Log.h"
#include "Util.h"
#include "ASString.h"
#include "LogNCrash.h"
#include "Singleton.hpp"
#include "CommonAPI.hpp"
#include "EncodedDatum.h"
#include "DetectManager.hpp"
#include "PatternManager.hpp"
#include "ResponseManager.hpp"

#define CHECK_BYTE_SIZE 8
#define OBJC_CLASS_NUM 3
#define AG_CLASS_NUM 3
#define API_NUM 35
#define VALID_SVC_CALL_SIGNATURE_MAX 8
#define VALID_SVC_CALL_NUM 1

// fishhook //
#ifdef __LP64__
typedef struct mach_header_64 mach_header_t;
typedef struct segment_command_64 segment_command_t;
typedef struct section_64 section_t;
typedef struct nlist_64 nlist_t;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT_64
#else
typedef struct mach_header mach_header_t;
typedef struct segment_command segment_command_t;
typedef struct section section_t;
typedef struct nlist nlist_t;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT
#endif

#ifndef SEG_DATA_CONST
#define SEG_DATA_CONST  "__DATA_CONST"
#endif

struct rebindings_entry
{
  struct rebinding *rebindings;
  size_t rebindings_nel;
  struct rebindings_entry *next;
};

struct rebinding
{
  const char *name;
  void *replacement;
  void **replaced;
};

struct valid_svc_call //system api hooked by frida entry
{
    const void* funcAddr;
    const uint8_t vaildSignature[VALID_SVC_CALL_SIGNATURE_MAX];
    const size_t signitureSize;
    const size_t signatureOffset;
};

static struct rebindings_entry *_rebindings_head;
static ssize_t (*orgS)(int sockfd, const void *buf, size_t len, int flags);
static ssize_t (*orgSt)(int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *dest_addr, socklen_t addrlen);
static ssize_t (*orgSm)(int sockfd, const struct msghdr *msg, int flags);
static ssize_t (*orgR)(int sockfd, void *buf, size_t len, int flags);
static ssize_t (*orgRf)(int sockfd, void *buf, size_t len, int flags, struct sockaddr *src_addr, socklen_t *addrlen);
static ssize_t (*orgRm)(int sockfd, struct msghdr *msg, int flags);

class __attribute__((visibility("hidden"))) HookManager
{
public:
    char* checkSystemAPIHook();
    char* checkObjCAPIHook();
    char* checkAppGuardAPIHook();
    char* checkValidSvcCallHook();
    void checkUserMethodHook(const char* className, const char* methodName);
    void swizzlingAppGuardAPIA();
    void swizzlingAppGuardAPIB();
    void stopNetworkA();
    void stopNetworkB();
    void stopNetworkC();
    void stopNetworkD();
private:
    const char* checkByte_ = "\x50\x00\x00\x58\x00\x02\x1f\xd6";
    void* api[API_NUM] = {(void*)exit, (void*)_exit, (void*)fork, (void*)stat, (void*)lstat, (void*)dlopen,  (void*)dlsym, (void*)_dyld_get_image_name, (void*)rmdir, (void*)chdir, (void*)fchdir,(void*)fstatat,(void*)link, (void*)popen, (void*)setgid, (void*)setuid, (void*)setegid, (void*)seteuid, (void*)getuid, (void*)getgid, (void*)geteuid, (void*)getegid, (void*)setreuid, (void*)setregid, (void*)sysctl, (void*)open, (void*)fopen, (void*)access, (void*)rename, (void*)getenv, (void*)regcomp, (void*)syscall,
        (void*)dladdr, (void*)sleep,(void*)usleep
    };
    
    const struct valid_svc_call kValidSvcCall[VALID_SVC_CALL_NUM] = {
        {
            (void*)lstat,
            {0x01,0x10,0x00,0xD4}, //svc #0x80
            4,
            4
        }
    };
    
    bool checkAPIByte(void* funcAddr);
    Method getAGMethod(const char* methodName);
    
    // fishhook //
    static int prepend_rebindings(struct rebindings_entry **rebindings_head, struct rebinding rebindings[], size_t nel);
    static vm_prot_t get_protection(void *sectionStart);
    static void perform_rebinding_with_section(struct rebindings_entry *rebindings, section_t *section, intptr_t slide, nlist_t *symtab, char *strtab, uint32_t *indirect_symtab);
    static void rebind_symbols_for_image(struct rebindings_entry *rebindings, const struct mach_header *header, intptr_t slide);
    static void _rebind_symbols_for_image(const struct mach_header *header, intptr_t slide);
    int rebind_symbols_image(void *header, intptr_t slide, struct rebinding rebindings[], size_t rebindings_nel);
    int rebind_symbols(struct rebinding rebindings[], size_t rebindings_nel);
    
    static ssize_t mySend(int sockfd, const void *buf, size_t len, int flags);
    static ssize_t mySendto(int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *dest_addr, socklen_t addrlen);
    static ssize_t mySendmsg(int sockfd, const struct msghdr *msg, int flags);
    static ssize_t myRecv(int sockfd, void *buf, size_t len, int flags);
    static ssize_t myRecvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *src_addr, socklen_t *addrlen);
    static ssize_t myRecvmsg(int sockfd, struct msghdr *msg, int flags);
};
#endif /* HookManager_hpp */
