var _string_interns: String**;

struct String {
	var length: UInt;
	var string: UInt8*;
};

func String_equal(string: String*, str: UInt8*, length: UInt): Bool {
	if (string->length != length) { return false; };
	return StringEqual(string->string, str, length);
};

func String_init(str: UInt8*, length: UInt): String* {
	var i = 0;
	while (i < Buffer_getCount((Void**)_string_interns)) {
		if (String_equal(_string_interns[i], str, length)) {
			return _string_interns[i];
		};
		i = i + 1;
	};
	var s = (String*)xcalloc(1, sizeof(String));
	s->length = length;
	s->string = StringDuplicate(str, length);
	Buffer_append((Void***)&_string_interns, (Void*)s);
	return s;
};

func String_init_literal(string: UInt8*): String* {
	return String_init(string, stringLength(string));
};

func String_print(stream: FILE*, string: String*) {
	fprintf(stream, (char*)"%.*s", (int)string->length, string->string);
};

func String_print_escaped(stream: FILE*, string: String*) {
	var i = 0;
	while (i < string->length) {
		if (string->string[i] == '\t') {
			fprintf(stream, (char*)"\\t");
		} else if (string->string[i] == '\n') {
			fprintf(stream, (char*)"\\n");
		} else if (string->string[i] == '\\') {
			fprintf(stream, (char*)"\\\\");
		} else if (string->string[i] == '\'') {
			fprintf(stream, (char*)"\\'");
		} else if (string->string[i] == '\"') {
			fprintf(stream, (char*)"\\\"");
		} else {
			fprintf(stream, (char*)"%c", string->string[i]);
		};;;;;
		i = i + 1;
	};
};



var _strings: UInt8**;

func intern(string: UInt8*, length: UInt): UInt8* {
	var i = 0;
	while (i < Buffer_getCount((Void**)_strings)) {
		if (length == stringLength(_strings[i])) {
			if (strncmp((char*)_strings[i], (char*)string, length) == (int)0) {
				return _strings[i];
			};
		};
		i = i + 1;
	};
	var newString = (UInt8*)strndup((char*)string, length);
	Buffer_append((Void***)&_strings, (Void*)newString);
	return newString;
};

func internLiteral(string: UInt8*): UInt8* {
	return intern(string, stringLength(string));
};

func stringLength(string: UInt8*): UInt {
	return strlen((char*)string);
};
