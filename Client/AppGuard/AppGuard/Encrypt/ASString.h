// AppGuard Security String header
// author : sangjin.yun

#ifndef ASString_h
#define ASString_h

#include <string.h>
#import "CommonAPI.hpp"
#import "Singleton.hpp"

#define SECURE_STRING(x) ASString(EncodedDatum::keys_[EncodedDatum::x],EncodedDatum::encoded_[EncodedDatum::x]).getString()
#define NS_SECURE_STRING(x) C2NSString(SECURE_STRING(x))

class __attribute__((visibility("hidden"))) ASString
{
public:
	ASString(const char* key, const char* encodedStr);
	~ASString();
	char* getString();

private:
	char key[4];
	char* decodedString_ = 0;
	char plainString_[1024];
	char* overPlainString_ = 0;
	bool over_ = false;

	int decode(const char* key, char* str);
};

#endif
