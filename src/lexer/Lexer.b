var _tokens: Token**;
var _tokenCount = (UInt)0;

func Lex(code: UInt8*, codeLength: UInt) {
	InitTokenKinds();
	
	_tokens = (Token**)xcalloc(codeLength, sizeof(Token*));
	_tokenCount = (UInt)0;
	
	while (true) {
		var token: Token*;
		
		if (*code == (UInt8)32) {
			while (isspace(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
		} else if (*code == (UInt8)9) {
			while (isspace(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
		} else if (*code == (UInt8)10) {
			while (isspace(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
		} else if (*code == (UInt8)44) {
			token = newToken();
			token->kind = TokenKind_Comma;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)58) {
			token = newToken();
			token->kind = TokenKind_Colon;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)59) {
			token = newToken();
			token->kind = TokenKind_Semicolon;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)123) {
			token = newToken();
			token->kind = TokenKind_OpenCurly;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)125) {
			token = newToken();
			token->kind = TokenKind_CloseCurly;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)91) {
			token = newToken();
			token->kind = TokenKind_OpenBracket;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)93) {
			token = newToken();
			token->kind = TokenKind_CloseBracket;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)40) {
			token = newToken();
			token->kind = TokenKind_OpenParenthesis;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)41) {
			token = newToken();
			token->kind = TokenKind_CloseParenthesis;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)64) {
			token = newToken();
			token->kind = TokenKind_At;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)42) {
			token = newToken();
			token->kind = TokenKind_Star;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)38) {
			token = newToken();
			token->kind = TokenKind_And;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			if (*code == (UInt8)38) {
				code = (UInt8*)((UInt)code + sizeof(UInt8));
				token->kind = TokenKind_AndAnd;
				token->length = (UInt)2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)124) {
			token = newToken();
			token->kind = TokenKind_Invalid;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			if (*code == (UInt8)124) {
				code = (UInt8*)((UInt)code + sizeof(UInt8));
				token->kind = TokenKind_OrOr;
				token->length = (UInt)2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)43) {
			token = newToken();
			token->kind = TokenKind_Plus;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)45) {
			token = newToken();
			token->kind = TokenKind_Minus;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			if (*code == (UInt8)62) {
				code = (UInt8*)((UInt)code + sizeof(UInt8));
				token->kind = TokenKind_Arrow;
				token->length = (UInt)2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)47) {
			token = newToken();
			token->kind = TokenKind_Slash;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)33) {
			token = newToken();
			token->kind = TokenKind_Not;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			if (*code == (UInt8)61) {
				code = (UInt8*)((UInt)code + sizeof(UInt8));
				token->kind = TokenKind_NotEqual;
				token->length = (UInt)2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)61) {
			token = newToken();
			token->kind = TokenKind_Assign;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			if (*code == (UInt8)61) {
				code = (UInt8*)((UInt)code + sizeof(UInt8));
				token->kind = TokenKind_Equal;
				token->length = (UInt)2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)60) {
			token = newToken();
			token->kind = TokenKind_LessThan;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)46) {
			if (code[(UInt)1] == (UInt8)46 && code[(UInt)2] == (UInt8)46) {
				token = newToken();
				token->kind = TokenKind_Ellipses;
				token->value = code;
				code = (UInt8*)((UInt)code + (UInt)3);
				token->length = (UInt)3;
				_tokens[_tokenCount] = token;
				_tokenCount = _tokenCount + (UInt)1;
			};
		} else if (*code == (UInt8)34) {
			token = newToken();
			token->kind = TokenKind_StringLiteral;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->value = code;
			while (*code != (UInt8)34 && *code != (UInt8)92 && isprint(*code)) {
				code = (UInt8*)((UInt)code + sizeof(UInt8));
			};
			token->length = (UInt)code - (UInt)token->value;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)48) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)49) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)50) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)51) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)52) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)53) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)54) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)55) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)56) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)57) {
			token = newToken();
			token->kind = TokenKind_IntegerLiteral;
			token->value = code;
			while (isdigit(*code)) { code = (UInt8*)((UInt)code + sizeof(UInt8)); };
			token->length = (UInt)code - (UInt)token->value;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
		} else if (*code == (UInt8)65) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)66) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)67) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)68) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)69) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)70) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)71) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)72) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)73) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)74) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)75) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)76) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)77) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)78) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)79) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)80) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)81) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)82) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)83) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)84) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)85) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)86) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)87) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)88) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)89) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)90) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)97) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)98) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)99) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)100) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)101) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)102) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)103) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)104) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)105) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)106) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)107) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)108) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)109) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)110) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)111) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)112) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)113) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)114) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)115) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)116) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)117) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)118) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)119) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)120) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)121) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)122) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)95) {
			lexStringLiteral(&code);
		} else if (*code == (UInt8)0) {
			token = newToken();
			token->kind = TokenKind_EOF;
			token->value = code;
			code = (UInt8*)((UInt)code + sizeof(UInt8));
			token->length = (UInt)1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + (UInt)1;
			return;
		} else {
			printTokens(_tokens, _tokenCount);
			if (isprint(*code)) {
				fprintf(stderr, (char*)"Unexpected character: '%c'%c", *code, 10);
			} else {
				fprintf(stderr, (char*)"Unexpected character: %02X%c", *code, 10);
			};
			exit(EXIT_FAILURE);
		};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	};
};

func lexStringLiteral(code: UInt8**) {
	var token = newToken();
	token->value = *code;
	while (isalnum(**code) || **code == (UInt8)95) { *code = (UInt8*)((UInt)*code + (UInt)1); };
	token->length = (UInt)*code - (UInt)token->value;
	if (token->length == (UInt)4 && strncmp((char*)token->value, (char*)"NULL", token->length) == (int)0) {
		token->kind = TokenKind_NULL;
	} else if (token->length == (UInt)6 && strncmp((char*)token->value, (char*)"sizeof",  token->length) == (int)0) {
		token->kind = TokenKind_Sizeof;
	} else if (token->length == (UInt)3 && strncmp((char*)token->value, (char*)"var",  token->length) == (int)0) {
		token->kind = TokenKind_Var;
	} else if (token->length == (UInt)4 && strncmp((char*)token->value, (char*)"func",  token->length) == (int)0) {
		token->kind = TokenKind_Func;
	} else if (token->length == (UInt)6 && strncmp((char*)token->value, (char*)"struct", token->length) == (int)0) {
		token->kind = TokenKind_Struct;
	} else if (token->length == (UInt)2 && strncmp((char*)token->value, (char*)"if", token->length) == (int)0) {
		token->kind = TokenKind_If;
	} else if (token->length == (UInt)4 && strncmp((char*)token->value, (char*)"else", token->length) == (int)0) {
		token->kind = TokenKind_Else;
	} else if (token->length == (UInt)5 && strncmp((char*)token->value, (char*)"while", token->length) == (int)0) {
		token->kind = TokenKind_While;
	} else if (token->length == (UInt)6 && strncmp((char*)token->value, (char*)"return",  token->length) == (int)0) {
		token->kind = TokenKind_Return;
	} else if (token->length == (UInt)4 && strncmp((char*)token->value, (char*)"true",  token->length) == (int)0) {
		token->kind = TokenKind_BooleanLiteral;
	} else if (token->length == (UInt)5 && strncmp((char*)token->value, (char*)"false",  token->length) == (int)0) {
		token->kind = TokenKind_BooleanLiteral;
	} else {
		token->kind = TokenKind_Identifier;
	};;;;;;;;;;;
	_tokens[_tokenCount] = token;
	_tokenCount = _tokenCount + (UInt)1;
};
