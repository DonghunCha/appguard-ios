//
//  Base64.h
//  appguard-ios
//
//  Created by NHNEnt on 2016. 6. 1..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef Base64_h
#define Base64_h

#pragma once

#include <stdio.h>

class __attribute__((visibility("hidden"))) Base64
{
private:
    static char MimeBase64[64];
    static int DecodeMimeBase64[256];
    
public:
    static int decode(char* data, unsigned char* decodeData, int numBytes);
    static int encode(unsigned char* data, int numBytes, char* encodedData);
};

#endif /* Base64_h */
