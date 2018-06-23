func StringEqual(str1: UInt8*, str2: UInt8*, length: UInt): Bool {
	return strncmp((char*)str1, (char*)str2, length) == (int)0;
};

func StringDuplicate(str: UInt8*, length: UInt): UInt8* {
	return (UInt8*)strndup((char*)str, length);
};
