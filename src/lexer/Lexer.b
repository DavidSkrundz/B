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
			lexToken(TokenKind_Comma, &code);
		} else if (*code == (UInt8)58) {
			lexToken(TokenKind_Colon, &code);
		} else if (*code == (UInt8)59) {
			lexToken(TokenKind_Semicolon, &code);
		} else if (*code == (UInt8)123) {
			lexToken(TokenKind_OpenCurly, &code);
		} else if (*code == (UInt8)125) {
			lexToken(TokenKind_CloseCurly, &code);
		} else if (*code == (UInt8)91) {
			lexToken(TokenKind_OpenBracket, &code);
		} else if (*code == (UInt8)93) {
			lexToken(TokenKind_CloseBracket, &code);
		} else if (*code == (UInt8)40) {
			lexToken(TokenKind_OpenParenthesis, &code);
		} else if (*code == (UInt8)41) {
			lexToken(TokenKind_CloseParenthesis, &code);
		} else if (*code == (UInt8)64) {
			lexToken(TokenKind_At, &code);
		} else if (*code == (UInt8)42) {
			lexToken(TokenKind_Star, &code);
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
			lexToken(TokenKind_Plus, &code);
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
			lexToken(TokenKind_Slash, &code);
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
			lexToken(TokenKind_LessThan, &code);
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
		} else if ((UInt8)47 < *code && *code < (UInt8)58) {
			lexIntegerLiteral(&code);
		} else if ((UInt8)64 < *code && *code < (UInt8)91) {
			lexStringLiteral(&code);
		} else if ((UInt8)96 < *code && *code < (UInt8)123) {
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
		};;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	};
};

func lexToken(kind: UInt, code: UInt8**) {
	var token = newToken();
	token->kind = kind;
	token->value = *code;
	*code = (UInt8*)((UInt)*code + sizeof(UInt8));
	token->length = (UInt)1;
	_tokens[_tokenCount] = token;
	_tokenCount = _tokenCount + (UInt)1;
};

func lexIntegerLiteral(code: UInt8**) {
	var token = newToken();
	token->kind = TokenKind_IntegerLiteral;
	token->value = *code;
	while (isdigit(**code)) { *code = (UInt8*)((UInt)*code + sizeof(UInt8)); };
	token->length = (UInt)*code - (UInt)token->value;
	_tokens[_tokenCount] = token;
	_tokenCount = _tokenCount + (UInt)1;
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
