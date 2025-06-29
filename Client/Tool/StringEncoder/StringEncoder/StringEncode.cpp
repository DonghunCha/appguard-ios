//
//  StringEncode.cpp
//  StringEncoder
//
//  Created by NHNENT on 2016. 5. 18..
//  Copyright © 2016년 NHNENT. All rights reserved.
//

#include "StringEncode.hpp"
#include <memory.h>

StringEncode::StringEncode()
{
    memset(textData_, 0, 1024);
}

StringEncode::~StringEncode()
{
}

const char* StringEncode::textXOR(const char *data, const char* key)
{
    unsigned long nBytes = strlen(data);
    int i = 0;
    if (nBytes < 4)
    {
        return nullptr;
    }
    
    while (i < nBytes)
    {
        textData_[i] = data[i] ^ key[i % 4];
        i++;
    }

    return textData_;
}

const char* StringEncode::getHexCode()
{
    convertHexData(textData_);
    return textHexData_;
}

unsigned char StringEncode::hexDigit(unsigned char d)
{
    if((d >= '0') && (d <= '9'))
    {
        return d - '0';
    }
    else if ((d >= 'a') && (d <= 'f'))
    {
        return d - 'a' + 10;
    }
    else if ((d >= 'A') && (d <= 'F'))
    {
        return d - 'A' + 10;
    }
    
    return 0;
}

unsigned StringEncode::strToHex(const char* str)
{
    unsigned result = 0;
    while (*str)
    {
        result <<= 4;
        result |= hexDigit(*str++);
    }
    
    return result;
}

void StringEncode::convertHexData(const char *data)
{
    unsigned long len = strlen(data);
    memset(textHexData_, 0, 2048);
    
    strcat(textHexData_, "{");
    for (int idx = 0; idx < len; idx++)
    {
        char hex[8+1] = {0,};
        sprintf(hex, "\'\\x%02X\', ", data[idx]);
        strcat(textHexData_, hex);
    }
    strcat(textHexData_, " \'\\0'},");
}

