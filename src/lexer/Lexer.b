var _code: UInt8*;
var _codeLength = 0;

var _tokens: Token**;
var _tokenCount = 0;

func Lex() {
	InitTokenKinds();
	
	_tokens = (Token**)xcalloc(_codeLength, sizeof(Token*));
	_tokenCount = 0;
	
	while (true) {
		var token: Token*;
		
		if (*_code == (UInt8)32) {
			while (isspace(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
		} else if (*_code == (UInt8)9) {
			while (isspace(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
		} else if (*_code == (UInt8)10) {
			while (isspace(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
		} else if (*_code == (UInt8)44) {
			lexToken(TokenKind_Comma);
		} else if (*_code == (UInt8)58) {
			lexToken(TokenKind_Colon);
		} else if (*_code == (UInt8)59) {
			lexToken(TokenKind_Semicolon);
		} else if (*_code == (UInt8)123) {
			lexToken(TokenKind_OpenCurly);
		} else if (*_code == (UInt8)125) {
			lexToken(TokenKind_CloseCurly);
		} else if (*_code == (UInt8)91) {
			lexToken(TokenKind_OpenBracket);
		} else if (*_code == (UInt8)93) {
			lexToken(TokenKind_CloseBracket);
		} else if (*_code == (UInt8)40) {
			lexToken(TokenKind_OpenParenthesis);
		} else if (*_code == (UInt8)41) {
			lexToken(TokenKind_CloseParenthesis);
		} else if (*_code == (UInt8)64) {
			lexToken(TokenKind_At);
		} else if (*_code == (UInt8)42) {
			lexToken(TokenKind_Star);
		} else if (*_code == (UInt8)38) {
			token = newToken();
			token->kind = TokenKind_And;
			token->value = _code;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			token->length = 1;
			if (*_code == (UInt8)38) {
				_code = (UInt8*)((UInt)_code + sizeof(UInt8));
				token->kind = TokenKind_AndAnd;
				token->length = 2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + 1;
		} else if (*_code == (UInt8)124) {
			token = newToken();
			token->kind = TokenKind_Invalid;
			token->value = _code;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			token->length = 1;
			if (*_code == (UInt8)124) {
				_code = (UInt8*)((UInt)_code + sizeof(UInt8));
				token->kind = TokenKind_OrOr;
				token->length = 2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + 1;
		} else if (*_code == (UInt8)43) {
			lexToken(TokenKind_Plus);
		} else if (*_code == (UInt8)45) {
			token = newToken();
			token->kind = TokenKind_Minus;
			token->value = _code;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			token->length = 1;
			if (*_code == (UInt8)62) {
				_code = (UInt8*)((UInt)_code + sizeof(UInt8));
				token->kind = TokenKind_Arrow;
				token->length = 2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + 1;
		} else if (*_code == (UInt8)47) {
			lexToken(TokenKind_Slash);
		} else if (*_code == (UInt8)33) {
			token = newToken();
			token->kind = TokenKind_Not;
			token->value = _code;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			token->length = 1;
			if (*_code == (UInt8)61) {
				_code = (UInt8*)((UInt)_code + sizeof(UInt8));
				token->kind = TokenKind_NotEqual;
				token->length = 2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + 1;
		} else if (*_code == (UInt8)61) {
			token = newToken();
			token->kind = TokenKind_Assign;
			token->value = _code;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			token->length = 1;
			if (*_code == (UInt8)61) {
				_code = (UInt8*)((UInt)_code + sizeof(UInt8));
				token->kind = TokenKind_Equal;
				token->length = 2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + 1;
		} else if (*_code == (UInt8)60) {
			token = newToken();
			token->kind = TokenKind_LessThan;
			token->value = _code;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			token->length = 1;
			if (*_code == (UInt8)61) {
				_code = (UInt8*)((UInt)_code + sizeof(UInt8));
				token->kind = TokenKind_LessThanEqual;
				token->length = 2;
			};
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + 1;
		} else if (*_code == (UInt8)46) {
			if (_code[1] == (UInt8)46 && _code[2] == (UInt8)46) {
				token = newToken();
				token->kind = TokenKind_Ellipses;
				token->value = _code;
				_code = (UInt8*)((UInt)_code + 3);
				token->length = 3;
				_tokens[_tokenCount] = token;
				_tokenCount = _tokenCount + 1;
			};
		} else if (*_code == (UInt8)34) {
			token = newToken();
			token->kind = TokenKind_StringLiteral;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			token->value = _code;
			while (*_code != (UInt8)34 && *_code != (UInt8)92 && isprint(*_code)) {
				_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			};
			token->length = (UInt)_code - (UInt)token->value;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + 1;
		} else if ('0' <= *_code && *_code <= '9') {
			lexIntegerLiteral();
		} else if (*_code == (UInt8)39) {
			lexCharacterLiteral();
		} else if ('A' <= *_code && *_code <= 'Z') {
			lexStringLiteral();
		} else if ('a' <= *_code && *_code <= 'z') {
			lexStringLiteral();
		} else if (*_code == (UInt8)95) {
			lexStringLiteral();
		} else if (*_code == (UInt8)0) {
			token = newToken();
			token->kind = TokenKind_EOF;
			token->value = _code;
			_code = (UInt8*)((UInt)_code + sizeof(UInt8));
			token->length = 1;
			_tokens[_tokenCount] = token;
			_tokenCount = _tokenCount + 1;
			return;
		} else {
			printTokens(_tokens, _tokenCount);
			if (isprint(*_code)) {
				fprintf(stderr, (char*)"Unexpected character: '%c'%c", *_code, 10);
			} else {
				fprintf(stderr, (char*)"Unexpected character: %02X%c", *_code, 10);
			};
			exit(EXIT_FAILURE);
		};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	};
};

func lexToken(kind: UInt) {
	var token = newToken();
	token->kind = kind;
	token->value = _code;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->length = 1;
	_tokens[_tokenCount] = token;
	_tokenCount = _tokenCount + 1;
};

func lexIntegerLiteral() {
	var token = newToken();
	token->kind = TokenKind_IntegerLiteral;
	token->value = _code;
	while (isdigit(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
	token->length = (UInt)_code - (UInt)token->value;
	_tokens[_tokenCount] = token;
	_tokenCount = _tokenCount + 1;
};

func lexCharacterLiteral() {
	var token = newToken();
	token->kind = TokenKind_CharacterLiteral;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->value = _code;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->length = 1;
	_tokens[_tokenCount] = token;
	_tokenCount = _tokenCount + 1;
};

func lexStringLiteral() {
	var token = newToken();
	token->value = _code;
	while (isalnum(*_code) || *_code == (UInt8)95) { _code = (UInt8*)((UInt)_code + 1); };
	token->length = (UInt)_code - (UInt)token->value;
	if (token->length == 4 && strncmp((char*)token->value, (char*)"NULL", token->length) == (int)0) {
		token->kind = TokenKind_NULL;
	} else if (token->length == 6 && strncmp((char*)token->value, (char*)"sizeof",  token->length) == (int)0) {
		token->kind = TokenKind_Sizeof;
	} else if (token->length == 3 && strncmp((char*)token->value, (char*)"var",  token->length) == (int)0) {
		token->kind = TokenKind_Var;
	} else if (token->length == 4 && strncmp((char*)token->value, (char*)"func",  token->length) == (int)0) {
		token->kind = TokenKind_Func;
	} else if (token->length == 6 && strncmp((char*)token->value, (char*)"struct", token->length) == (int)0) {
		token->kind = TokenKind_Struct;
	} else if (token->length == 2 && strncmp((char*)token->value, (char*)"if", token->length) == (int)0) {
		token->kind = TokenKind_If;
	} else if (token->length == 4 && strncmp((char*)token->value, (char*)"else", token->length) == (int)0) {
		token->kind = TokenKind_Else;
	} else if (token->length == 5 && strncmp((char*)token->value, (char*)"while", token->length) == (int)0) {
		token->kind = TokenKind_While;
	} else if (token->length == 6 && strncmp((char*)token->value, (char*)"return",  token->length) == (int)0) {
		token->kind = TokenKind_Return;
	} else if (token->length == 4 && strncmp((char*)token->value, (char*)"true",  token->length) == (int)0) {
		token->kind = TokenKind_BooleanLiteral;
	} else if (token->length == 5 && strncmp((char*)token->value, (char*)"false",  token->length) == (int)0) {
		token->kind = TokenKind_BooleanLiteral;
	} else {
		token->kind = TokenKind_Identifier;
	};;;;;;;;;;;
	_tokens[_tokenCount] = token;
	_tokenCount = _tokenCount + 1;
};
