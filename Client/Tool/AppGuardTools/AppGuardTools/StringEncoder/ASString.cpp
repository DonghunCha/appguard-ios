#include "ASString.h"
#include <string.h>

ASString::ASString(const char* key, const char* encodedStr)
{
	memset(plainString_, 0, 1024);
	if (encodedStr != nullptr)
	{
		int len = strlen(encodedStr);
		if (len > 1023)
		{
			overPlainString_ = new char[len + 1];
			memset(overPlainString_, 0, len);
			over_ = true;
			strcpy(overPlainString_, encodedStr);
			decodedString_ = overPlainString_;
		}
		else
		{
			strcpy(plainString_, encodedStr);
			decodedString_ = plainString_;
		}

		decode(key, decodedString_);
	}
}

ASString::~ASString()
{
	if (over_ == true && overPlainString_ != nullptr)
	{
		delete overPlainString_;
		overPlainString_ = nullptr;
		decodedString_ = nullptr;
	}
}

int ASString::decode(const char* key, char* str)
{
	int nBytes = strlen(str);
	
	int i = 0;
	if (nBytes < 4)
	{
		return 0;
	}

	while (i < nBytes)
	{
		str[i] ^= key[i % 4];
		i++;
	}
	return 0;
}

char* ASString::getString()
{
	return decodedString_;
}

