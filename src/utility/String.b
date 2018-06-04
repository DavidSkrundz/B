var _strings: UInt8**;

func intern(string: UInt8*, length: UInt): UInt8* {
	var i = 0;
	while (i < bufferCount((Void**)_strings)) {
		if (length == stringLength(_strings[i])) {
			if (strncmp((char*)_strings[i], (char*)string, length) == (int)0) {
				return _strings[i];
			};
		};
		i = i + 1;
	};
	var newString = (UInt8*)strndup((char*)string, length);
	append((Void***)&_strings, (Void*)newString);
	return newString;
};

func internLiteral(string: UInt8*): UInt8* {
	return intern(string, stringLength(string));
};

func stringLength(string: UInt8*): UInt {
	return strlen((char*)string);
};
