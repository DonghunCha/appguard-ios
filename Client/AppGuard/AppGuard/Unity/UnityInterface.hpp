//
//  UnityInterface.hpp
//  AppGuard
//
//  Created by NHN on 2023/05/08.
//

#ifndef UnityInterface_h
#define UnityInterface_h


extern "C" {
    __attribute__((visibility("default"))) int a(const char* username);
    __attribute__((visibility("default"))) int b(bool useAlert);
    __attribute__((visibility("default"))) void k(const char* signer);
    __attribute__((visibility("default"))) int c(void* pointer, bool useAlert);
    __attribute__((visibility("default"))) int d(const char* apikey, const char* version, const char* appName, const char* username);
    __attribute__((visibility("default"))) void h();
    __attribute__((visibility("default"))) void i();
    __attribute__((visibility("default"))) void e();
    __attribute__((visibility("default"))) void g();
    __attribute__((visibility("default"))) void z();
    __attribute__((visibility("default"))) void cs();
    __attribute__((visibility("default"))) void cc();
    __attribute__((visibility("default"))) char* dv(void);
//    __attribute__((visibility("default"))) void sp(bool active);
//    __attribute__((visibility("default"))) void sn(bool active);
}

#endif /* UnityInterface_h */
