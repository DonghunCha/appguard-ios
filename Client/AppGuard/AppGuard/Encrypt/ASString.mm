#include "ASString.h"

__attribute__((visibility("hidden"))) ASString::ASString(const char* key, const char* encodedStr)
{
	memset(plainString_, 0, 1024);
	if (encodedStr != NULL)
	{
		unsigned long len = STInstance(CommonAPI)->cStrlen(encodedStr);
		if (len > 1023)
		{
			overPlainString_ = new char[len + 1];
			memset(overPlainString_, 0, len);
			over_ = true;
            STInstance(CommonAPI)->cStrcpy(overPlainString_, encodedStr);
			decodedString_ = overPlainString_;
		}
		else
		{
            STInstance(CommonAPI)->cStrcpy(plainString_, encodedStr);
			decodedString_ = plainString_;
		}

		decode(key, decodedString_);
	}
}

__attribute__((visibility("hidden"))) ASString::~ASString()
{
	if (over_ == true && overPlainString_ != NULL)
	{
		delete overPlainString_;
		overPlainString_ = NULL;
		decodedString_ = NULL;
	}
}

__attribute__((visibility("hidden"))) int ASString::decode(const char* key, char* str)
{
	unsigned long nBytes = strlen(str);
	
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

__attribute__((visibility("hidden"))) char* ASString::getString()
{
	return decodedString_;
}

