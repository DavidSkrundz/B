var _code: UInt8*;
var _codeLength = 0;

var _tokens: Token**;

var _file: UInt8*;
var _start: UInt8*;
var _line = 0;
var _column = 0;

func Lex() {
	_tokens = NULL;
	InternKeywords();
	
	_line = 1;
	_column = 1;
	_start = _code;
	
	while (true) {
		if (*_code == ' ' || *_code == (UInt8)9 || *_code == (UInt8)10) {
			while (isspace(*_code)) {
				if (*_code == (UInt8)10) {
					_line = _line + 1;
					_column = 0;
					_start = (UInt8*)((UInt)_code + sizeof(UInt8));
				};
				advanceLexer(1);
			};
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
			LexerError();
		};;;;;;;;;;;;;;;;;;;;;;;;;;;;
	};
};

func advanceLexer(amount: UInt) {
	_column = _column + amount;
	_code = (UInt8*)((UInt)_code + amount * sizeof(UInt8));
};

func lexToken(kind: TokenKind) {
	var token = newToken();
	token->kind = kind;
	token->pos = newSrcPos(_file, _start, _line, _column);
	token->value = intern(_code, 1);
	advanceLexer(1);
	append((Void***)&_tokens, (Void*)token);
};

func lexToken2(kind: TokenKind, character2: UInt8, kind2: TokenKind) {
	var token = newToken();
	token->kind = kind;
	token->pos = newSrcPos(_file, _start, _line, _column);
	var start = _code;
	advanceLexer(1);
	if (*_code == character2) {
		token->value = intern(start, 2);
		token->kind = kind2;
		advanceLexer(1);
	} else {
		token->value = intern(start, 1);
	};
	append((Void***)&_tokens, (Void*)token);
};

func lexElipses() {
	var token = newToken();
	token->pos = newSrcPos(_file, _start, _line, _column);
	if (_code[1] == '.' && _code[2] == '.') {
		token->kind = .Ellipses;
		token->value = intern(_code, 3);
		advanceLexer(3);
	} else {
		token->kind = .Dot;
		token->value = intern(_code, 1);
		advanceLexer(1);
	};
	append((Void***)&_tokens, (Void*)token);
};

func lexIntegerLiteral() {
	var token = newToken();
	token->kind = .IntegerLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	var start = _code;
	while (isdigit(*_code)) { advanceLexer(1); };
	token->value = intern(start, (UInt)_code - (UInt)start);
	append((Void***)&_tokens, (Void*)token);
};

func lexStringLiteral() {
	if (*_code != (UInt8)34) { LexerError(); };
	var token = newToken();
	token->kind = .StringLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	advanceLexer(1);
	var start = _code;
	while (*_code != (UInt8)34 && *_code != (UInt8)92 && isprint(*_code)) {
		advanceLexer(1);
	};
	token->value = intern(start, (UInt)_code - (UInt)start);
	if (*_code != (UInt8)34) { LexerError(); };
	advanceLexer(1);
	append((Void***)&_tokens, (Void*)token);
};

func lexCharacterLiteral() {
	if (*_code != (UInt8)39) { LexerError(); };
	var token = newToken();
	token->kind = .CharacterLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	advanceLexer(1);
	token->value = intern(_code, 1);
	advanceLexer(1);
	if (*_code != (UInt8)39) { LexerError(); };
	advanceLexer(1);
	append((Void***)&_tokens, (Void*)token);
};

func lexIdentifier() {
	var token = newToken();
	var start = _code;
	token->pos = newSrcPos(_file, _start, _line, _column);
	while (isalnum(*_code) || *_code == '_') { advanceLexer(1); };
	token->value = intern(start, (UInt)_code - (UInt)start);
	token->kind = .Identifier;
	append((Void***)&_tokens, (Void*)token);
};
