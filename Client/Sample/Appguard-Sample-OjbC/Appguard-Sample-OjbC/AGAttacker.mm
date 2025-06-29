//
//  AGAttacker.m
//  Appguard-Sample-OjbC
//
//  Created by NHN on 2023/04/18.
//

#import "AGAttacker.hpp"
#import <mach/mach_init.h>
#import <mach/vm_map.h>
#import <mach/vm_prot.h>
#import <mach/vm_region.h>
#import <mach-o/dyld.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <AppGuard/Diresu.h>

#define LIB_SUBSTRATE "libsubstrate.dylib"
#define MSHOOK_FUNCTION_SYM "MSHookFunction"

typedef void (*MSHOOKFUNCTION)(void *symbol, void *hook, void **old);
static MSHOOKFUNCTION fpMSHookFunction = nullptr;

static int (*org_lstat)(const char* filename, struct stat *stat);
static int my_lstat(const char* filename, struct stat *stat) {
    NSLog(@"[+] AGAttacker: my_lstat fname=%s", filename);
    return org_lstat(filename, stat);
}

@implementation AGAttacker

+ (BOOL)binaryPatchAttack {
    
    vm_address_t fucAddr = (vm_address_t)checkSwizzled; //Diresu의 checkSwizzled 함수 패치
    kern_return_t kr;
    mach_port_t port = mach_task_self();
    
    kr = vm_protect(port, trunc_page(fucAddr), vm_page_size, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    if (kr != KERN_SUCCESS) {
         NSLog(@"[+] AGAttacker: vm_protect failed\n");
         return NO;
    }
    NSLog(@"[+] AGAttacker: vm_protect success VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY\n");
    const char* code = "\xC0\x03\x5F\xD6";
     kr = vm_write(port, fucAddr, (vm_offset_t)code, 4);
     if (kr != KERN_SUCCESS) {
         NSLog(@"[+] AGAttacker: vm_write failed\n");
         return NO;
     }
 
    NSLog(@"[+] AGAttacker: vm_write success %p\n", checkSwizzled);
    kr = vm_protect(port, trunc_page(fucAddr), vm_page_size, false, VM_PROT_READ | VM_PROT_EXECUTE);
    if (kr != KERN_SUCCESS) {
        NSLog(@"[+] AGAttacker: vm_protect failed\n");
        return NO;
    }
    NSLog(@"[+] AGAttacker: vm_protect sucess VM_PROT_READ | VM_PROT_EXECUTE\n");

    return YES;
}

+ (int)findSubstrateIndex {
    uint32_t imageCount = _dyld_image_count();
    int imageIndex = -1;
    for(int i=0; i<imageCount; i++)
    {
        const char * name = _dyld_get_image_name(i);
        if(strstr(name, "libsubstrate.dylib")!=0)
        {
            NSLog(@"[+] AGAttacker: Found libsubstrate");
            imageIndex = i;
            break;
        }
    }
    return imageIndex;
}

+ (BOOL)hookingAttack {
    if([AGAttacker findSubstrateIndex] == -1) {
        NSLog(@"[+] AGAttacker: Not Found libsubstrate");
        return NO;
    }
    
    void* handle = (void*)dlopen(LIB_SUBSTRATE, RTLD_GLOBAL | RTLD_NOW);
    if(!handle) {
        NSLog(@"[+] AGAttacker: fail dlopen libsubstrate");
        return NO;
    }
    
    fpMSHookFunction = (MSHOOKFUNCTION)dlsym(handle, MSHOOK_FUNCTION_SYM);
    if(!fpMSHookFunction) {
        NSLog(@"[+] AGAttacker: fail dlsym %s", MSHOOK_FUNCTION_SYM);
        dlclose(handle);
        return NO;
    }
    
    fpMSHookFunction((void*)lstat, (void*)my_lstat, (void**)&org_lstat);
    NSLog(@"[+] AGAttacker: success hooking lstat.");
    dlclose(handle);
    return YES;
}
@end

