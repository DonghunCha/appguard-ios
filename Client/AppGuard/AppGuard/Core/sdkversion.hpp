//
//  sdkversion.hpp
//  AppGuard
//
//  Created by NHN on 2023/03/13.
//  Copyright © 2023 nhnent. All rights reserved.
//

#ifndef sdkversion_h
#define sdkversion_h

#define AG_SDK_VERSION_SIGNATURE "b3936adaa6240a9cf706d03aa01141689ff40fce40beb5f3e0a353ced48555f7"
#define AG_PROTECTOR_VERSION_SIGNATURE "0ba3e5b1017b810662256029dd82fe1a6969cd52e2247db8b6c64284431831fa" // for inserting protector version.
#define AG_SDK_MAJOR_VERSION 1
#define AG_SDK_MINOR_VERSION 4
#define AG_SDK_PATCH_VERSION 11
#define AG_SDK_RESERVED_VERSION_STRING "\0" // alpha? for pre-release


typedef struct _AG_SDK_VERSION{
    char signature[65];
    short major;
    short minor;
    short patch;
    char reserved[32];
    char protectorVersion[65];
}AG_SDK_VERSION, *PAG_SDK_VERSION;

#endif /* sdkversion_h */
