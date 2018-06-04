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
				_column = _column + 1;
				_code = (UInt8*)((UInt)_code + sizeof(UInt8));
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

func lexToken(kind: TokenKind) {
	var token = newToken();
	token->kind = kind;
	token->pos = newSrcPos(_file, _start, _line, _column);
	token->value = intern(_code, 1);
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->length = 1;
	_column = _column + token->length;
	append((Void***)&_tokens, (Void*)token);
};

func lexToken2(kind: TokenKind, character2: UInt8, kind2: TokenKind) {
	var token = newToken();
	token->kind = kind;
	token->pos = newSrcPos(_file, _start, _line, _column);
	var start = _code;
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->length = 1;
	if (*_code == character2) {
		_code = (UInt8*)((UInt)_code + sizeof(UInt8));
		token->value = intern(start, 2);
		token->kind = kind2;
		token->length = 2;
	} else {
		token->value = intern(start, 1);
	};
	_column = _column + token->length;
	append((Void***)&_tokens, (Void*)token);
};

func lexElipses() {
	var token = newToken();
	token->pos = newSrcPos(_file, _start, _line, _column);
	if (_code[1] == '.' && _code[2] == '.') {
		token->kind = .Ellipses;
		token->value = intern(_code, 3);
		_code = (UInt8*)((UInt)_code + 3);
		token->length = 3;
	} else {
		token->kind = .Dot;
		token->value = intern(_code, 1);
		_code = (UInt8*)((UInt)_code + 1);
		token->length = 1;
	};
	_column = _column + token->length;
	append((Void***)&_tokens, (Void*)token);
};

func lexIntegerLiteral() {
	var token = newToken();
	token->kind = .IntegerLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	var start = _code;
	while (isdigit(*_code)) { _code = (UInt8*)((UInt)_code + sizeof(UInt8)); };
	token->length = (UInt)_code - (UInt)start;
	token->value = intern(start, token->length);
	_column = _column + token->length;
	append((Void***)&_tokens, (Void*)token);
};

func lexStringLiteral() {
	var token = newToken();
	token->kind = .StringLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	var start = _code;
	while (*_code != (UInt8)34 && *_code != (UInt8)92 && isprint(*_code)) {
		_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	};
	token->length = (UInt)_code - (UInt)start;
	token->value = intern(start, token->length);
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	_column = _column + token->length + 2;
	append((Void***)&_tokens, (Void*)token);
};

func lexCharacterLiteral() {
	var token = newToken();
	token->kind = .CharacterLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->value = intern(_code, 1);
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	_code = (UInt8*)((UInt)_code + sizeof(UInt8));
	token->length = 1;
	_column = _column + token->length + 2;
	append((Void***)&_tokens, (Void*)token);
};

func lexIdentifier() {
	var token = newToken();
	var start = _code;
	token->pos = newSrcPos(_file, _start, _line, _column);
	while (isalnum(*_code) || *_code == '_') { _code = (UInt8*)((UInt)_code + 1); };
	token->length = (UInt)_code - (UInt)start;
	token->value = intern(start, token->length);
	_column = _column + token->length;
	if (token->value == Keyword_NULL) {
		token->kind = ._NULL;
	} else if (token->value == Keyword_Sizeof) {
		token->kind = .Sizeof;
	} else if (token->value == Keyword_Offsetof) {
		token->kind = .Offsetof;
	} else if (token->value == Keyword_Var) {
		token->kind = .Var;
	} else if (token->value == Keyword_Func) {
		token->kind = .Func;
	} else if (token->value == Keyword_Struct) {
		token->kind = .Struct;
	} else if (token->value == Keyword_Enum) {
		token->kind = .Enum;
	} else if (token->value == Keyword_If) {
		token->kind = .If;
	} else if (token->value == Keyword_Else) {
		token->kind = .Else;
	} else if (token->value == Keyword_While) {
		token->kind = .While;
	} else if (token->value == Keyword_Return) {
		token->kind = .Return;
	} else if (token->value == Keyword_Case) {
		token->kind = .Case;
	} else if (token->value == Keyword_True) {
		token->kind = .BooleanLiteral;
	} else if (token->value == Keyword_False) {
		token->kind = .BooleanLiteral;
	} else {
		token->kind = .Identifier;
	};;;;;;;;;;;;;;
	append((Void***)&_tokens, (Void*)token);
};
