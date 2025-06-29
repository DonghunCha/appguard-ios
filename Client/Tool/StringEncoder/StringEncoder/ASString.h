// AppGuard Security String header
// author : sangjin.yun


class ASString
{
public:
	ASString(const char* key, const char* encodedStr);
	~ASString();
	char* getString();

private:
	char key[4];
	char* decodedString_ = nullptr;
	char plainString_[1024];
	char* overPlainString_ = nullptr;
	bool over_ = false;

	int decode(const char* key, char* str);
};