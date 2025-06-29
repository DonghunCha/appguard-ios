//
//  StringEncode.hpp
//  StringEncoder
//
//  Created by NHNENT on 2016. 5. 18..
//  Copyright © 2016년 NHNENT. All rights reserved.
//

#ifndef StringEncode_hpp
#define StringEncode_hpp

#include <stdio.h>

class StringEncode
{
public:
    StringEncode();
    ~StringEncode();
    
    const char* textXOR(const char* data, const char* key);
    const char* getHexCode();
    bool isKeyValid(const char* data, const char* key);
    
private:
    char textData_[1024];
    char textHexData_[2048];
    
    unsigned char hexDigit(unsigned char d);
    unsigned strToHex(const char* str);
    void convertHexData(const char* data);
};

#endif /* StringEncode_hpp */
