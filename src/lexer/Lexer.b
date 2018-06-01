var _code: UInt8*;
var _codeLength = 0;

var _tokens: Token**;

func Lex() {
	_tokens = NULL;
	
	while (true) {
		if (*_code == ' ') {
			while (isspace(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
		} else if (*_code == (UInt8)9) {
			while (isspace(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
		} else if (*_code == (UInt8)10) {
			while (isspace(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
		} else if (*_code == ',') {
			lexToken(.Comma);
		} else if (*_code == ':') {
			lexToken(.Colon);
		} else if (*_code == ';') {
			lexToken(.Semicolon);
		} else if (*_code == '{') {
			lexToken(.OpenCurly);
		} else if (*_code == '}') {
			lexToken(.CloseCurly);
		} else if (*_code == '[') {
			lexToken(.OpenBracket);
		} else if (*_code == ']') {
			lexToken(.CloseBracket);
		} else if (*_code == '(') {
			lexToken(.OpenParenthesis);
		} else if (*_code == ')') {
			lexToken(.CloseParenthesis);
		} else if (*_code == '@') {
			lexToken(.At);
		} else if (*_code == '*') {
			lexToken(.Star);
		} else if (*_code == '&') {
			lexToken2(.And, '&', .AndAnd);
		} else if (*_code == '|') {
			lexToken2(.Invalid, '|', .OrOr);
		} else if (*_code == '+') {
			lexToken(.Plus);
		} else if (*_code == '-') {
			lexToken2(.Minus, '>', .Arrow);
		} else if (*_code == '/') {
			lexToken(.Slash);
		} else if (*_code == '!') {
			lexToken2(.Not, '=', .NotEqual);
		} else if (*_code == '=') {
			lexToken2(.Assign, '=', .Equal);
		} else if (*_code == '<') {
			lexToken2(.LessThan, '=', .LessThanEqual);
		} else if (*_code == '.') {
			lexElipses();
		} else if (*_code == (UInt8)34) {
			lexStringLiteral();
		} else if ('0' <= *_code && *_code <= '9') {
			lexIntegerLiteral();
		} else if (*_code == (UInt8)39) {
			lexCharacterLiteral();
		} else if ('A' <= *_code && *_code <= 'Z') {
			lexIdentifier();
		} else if ('a' <= *_code && *_code <= 'z') {
			lexIdentifier();
		} else if (*_code == '_') {
			lexIdentifier();
		} else if (*_code == (UInt8)0) {
			lexToken(.EOF);
			return;
		} else {
			printTokens();
			if (isprint(*_code)) {
				fprintf(stderr, (char*)"Unexpected character: '%c'%c", *_code, 10);
			} else {
				fprintf(stderr, (char*)"Unexpected character: %02X%c", *_code, 10);
			};
			exit(EXIT_FAILURE);
		};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	};
};

func lexToken(kind: TokenKind) {
	var token = newToken();
	token->kind = kind;
	token->value = _code;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->length = 1;
	append((Void***)&_tokens, (Void*)token);
};

func lexToken2(kind: TokenKind, character2: UInt8, kind2: TokenKind) {
	var token = newToken();
	token->kind = kind;
	token->value = _code;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->length = 1;
	if (*_code == character2) {
		_code = (UInt8*)((UInt)_code + sizeof(UInt8));
		token->kind = kind2;
		token->length = 2;
	};
	append((Void***)&_tokens, (Void*)token);
};

func lexElipses() {
	var token = newToken();
	token->value = _code;
	if (_code[1] == '.' && _code[2] == '.') {
		token->kind = .Ellipses;
		_code = (UInt8*)((UInt)_code + 3);
		token->length = 3;
	} else {
		token->kind = .Dot;
		_code = (UInt8*)((UInt)_code + 1);
		token->length = 1;
	};
	append((Void***)&_tokens, (Void*)token);
};

func lexIntegerLiteral() {
	var token = newToken();
	token->kind = .IntegerLiteral;
	token->value = _code;
	while (isdigit(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
	token->length = (UInt)_code - (UInt)token->value;
	append((Void***)&_tokens, (Void*)token);
};

func lexStringLiteral() {
	var token = newToken();
	token->kind = .StringLiteral;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->value = _code;
	while (*_code != (UInt8)34 && *_code != (UInt8)92 && isprint(*_code)) {
		_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	};
	token->length = (UInt)_code - (UInt)token->value;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	append((Void***)&_tokens, (Void*)token);
};

func lexCharacterLiteral() {
	var token = newToken();
	token->kind = .CharacterLiteral;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->value = _code;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->length = 1;
	append((Void***)&_tokens, (Void*)token);
};

func lexIdentifier() {
	var token = newToken();
	token->value = _code;
	while (isalnum(*_code) || *_code == '_') { _code = (UInt8*)((UInt)_code + 1); };
	token->length = (UInt)_code - (UInt)token->value;
	if (token->length == 4 && strncmp((char*)token->value, (char*)"NULL", token->length) == (int)0) {
		token->kind = ._NULL;
	} else if (token->length == 6 && strncmp((char*)token->value, (char*)"sizeof",  token->length) == (int)0) {
		token->kind = .Sizeof;
	} else if (token->length == 8 && strncmp((char*)token->value, (char*)"offsetof",  token->length) == (int)0) {
		token->kind = .Offsetof;
	} else if (token->length == 3 && strncmp((char*)token->value, (char*)"var",  token->length) == (int)0) {
		token->kind = .Var;
	} else if (token->length == 4 && strncmp((char*)token->value, (char*)"func",  token->length) == (int)0) {
		token->kind = .Func;
	} else if (token->length == 6 && strncmp((char*)token->value, (char*)"struct", token->length) == (int)0) {
		token->kind = .Struct;
	} else if (token->length == 4 && strncmp((char*)token->value, (char*)"enum", token->length) == (int)0) {
		token->kind = .Enum;
	} else if (token->length == 2 && strncmp((char*)token->value, (char*)"if", token->length) == (int)0) {
		token->kind = .If;
	} else if (token->length == 4 && strncmp((char*)token->value, (char*)"else", token->length) == (int)0) {
		token->kind = .Else;
	} else if (token->length == 5 && strncmp((char*)token->value, (char*)"while", token->length) == (int)0) {
		token->kind = .While;
	} else if (token->length == 6 && strncmp((char*)token->value, (char*)"return",  token->length) == (int)0) {
		token->kind = .Return;
	} else if (token->length == 4 && strncmp((char*)token->value, (char*)"case", token->length) == (int)0) {
		token->kind = .Case;
	} else if (token->length == 4 && strncmp((char*)token->value, (char*)"true",  token->length) == (int)0) {
		token->kind = .BooleanLiteral;
	} else if (token->length == 5 && strncmp((char*)token->value, (char*)"false",  token->length) == (int)0) {
		token->kind = .BooleanLiteral;
	} else {
		token->kind = .Identifier;
	};;;;;;;;;;;;;;
	append((Void***)&_tokens, (Void*)token);
};
