var _code: UInt8*;
var _codeLength = 0;

var _tokens: Token**;

var _file: UInt8*;
var _start: UInt8*;
var _line = 0;
var _column = 0;

func _characterTo1TokenKind(character: UInt8): TokenKind {
	if (*_code == ',') {        return .Comma;
	} else if (*_code == ':') { return .Colon;
	} else if (*_code == ';') { return .Semicolon;
	} else if (*_code == '{') { return .OpenCurly;
	} else if (*_code == '}') { return .CloseCurly;
	} else if (*_code == '[') { return .OpenBracket;
	} else if (*_code == ']') { return .CloseBracket;
	} else if (*_code == '(') { return .OpenParenthesis;
	} else if (*_code == ')') { return .CloseParenthesis;
	} else if (*_code == '@') { return .At;
	} else if (*_code == '*') { return .Star;
	} else if (*_code == '+') { return .Plus;
	} else if (*_code == '/') { return .Slash;
	} else {                    return .Invalid;
	};;;;;;;;;;;;;
};

func _isCharacter1Token(character: UInt8): Bool {
	return _characterTo1TokenKind(character) != .Invalid;
};

func _characterTo2TokenKind1(character: UInt8): TokenKind {
	if (*_code == '&') {        return .And;
	} else if (*_code == '|') { return .Invalid;
	} else if (*_code == '-') { return .Minus;
	} else if (*_code == '!') { return .Not;
	} else if (*_code == '=') { return .Assign;
	} else if (*_code == '<') { return .LessThan;
	} else {                    return .Invalid;
	};;;;;;
};

func _characterTo2TokenKind2(character: UInt8): TokenKind {
	if (*_code == '&') {        return .AndAnd;
	} else if (*_code == '|') { return .OrOr;
	} else if (*_code == '-') { return .Arrow;
	} else if (*_code == '!') { return .NotEqual;
	} else if (*_code == '=') { return .Equal;
	} else if (*_code == '<') { return .LessThanEqual;
	} else {                    return .Invalid;
	};;;;;;
};

func _characterTo2TokenCharacter2(character: UInt8): UInt8 {
	if (*_code == '&') {        return '&';
	} else if (*_code == '|') { return '|';
	} else if (*_code == '-') { return '>';
	} else if (*_code == '!') { return '=';
	} else if (*_code == '=') { return '=';
	} else if (*_code == '<') { return '=';
	} else {                    return '\0';
	};;;;;;
};

func _isCharacter2Token(character: UInt8): Bool {
	return _characterTo2TokenKind1(character) != .Invalid ||
	       _characterTo2TokenKind2(character) != .Invalid;
};

func Lex() {
	_tokens = NULL;
	InternKeywords();
	
	_line = 1;
	_column = 1;
	_start = _code;
	
	while (true) {
		if (*_code == ' ' || *_code == '\t' || *_code == '\n') {
			while (isspace(*_code)) {
				var character = *_code;
				advanceLexer(1);
				if (character == '\n') {
					_line = _line + 1;
					_column = 1;
					_start = _code;
				};
			};
		} else if (_isCharacter1Token(*_code)) {
			lexToken(_characterTo1TokenKind(*_code));
		} else if (_isCharacter2Token(*_code)) {
			lexToken2(_characterTo2TokenKind1(*_code),
			          _characterTo2TokenCharacter2(*_code),
			          _characterTo2TokenKind2(*_code));
		} else if (*_code == '.') {
			lexElipses();
		} else if (*_code == '"') {
			lexStringLiteral();
		} else if ('0' <= *_code && *_code <= '9') {
			lexIntegerLiteral();
		} else if (*_code == '\'') {
			lexCharacterLiteral();
		} else if ('A' <= *_code && *_code <= 'Z') {
			lexIdentifier();
		} else if ('a' <= *_code && *_code <= 'z') {
			lexIdentifier();
		} else if (*_code == '_') {
			lexIdentifier();
		} else if (*_code == '\0') {
			lexToken(.EOF);
			return;
		} else {
			LexerError();
		};;;;;;;;;;;
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
	token->string = String_init(_code, 1);
	advanceLexer(1);
	Buffer_append((Void***)&_tokens, (Void*)token);
};

func lexToken2(kind: TokenKind, character2: UInt8, kind2: TokenKind) {
	var token = newToken();
	token->kind = kind;
	token->pos = newSrcPos(_file, _start, _line, _column);
	var start = _code;
	advanceLexer(1);
	if (*_code == character2) {
		token->string = String_init(start, 2);
		token->kind = kind2;
		advanceLexer(1);
	} else {
		token->string = String_init(start, 1);
	};
	Buffer_append((Void***)&_tokens, (Void*)token);
};

func lexElipses() {
	var token = newToken();
	token->pos = newSrcPos(_file, _start, _line, _column);
	if (_code[1] == '.' && _code[2] == '.') {
		token->kind = .Ellipses;
		token->string = String_init(_code, 3);
		advanceLexer(3);
	} else {
		token->kind = .Dot;
		token->string = String_init(_code, 1);
		advanceLexer(1);
	};
	Buffer_append((Void***)&_tokens, (Void*)token);
};

func lexIntegerLiteral() {
	var token = newToken();
	token->kind = .IntegerLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	var start = _code;
	while (isdigit(*_code)) { advanceLexer(1); };
	token->string = String_init(start, (UInt)_code - (UInt)start);
	Buffer_append((Void***)&_tokens, (Void*)token);
};

func lexStringLiteral() {
	if (*_code != '"') { LexerError(); };
	var token = newToken();
	token->kind = .StringLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	advanceLexer(1);
	var i = 0;
	while (_code[i] != '"' && isprint(_code[i])) { i = i + 1; };
	if (_code[i] != '"') { LexerError(); };
	var string = (UInt8*)xcalloc(i, sizeof(UInt8));
	i = 0;
	while (*_code != '"' && isprint(*_code)) {
		if (*_code == '\\') {
			advanceLexer(1);
			if (*_code == '\\') {
				string[i] = '\\';
			} else if (*_code == '\'') {
				string[i] = '\'';
			} else if (*_code == '"') {
				string[i] = '\"';
			} else if (*_code == 'n') {
				string[i] = '\n';
			} else if (*_code == 't') {
				string[i] = '\t';
			} else if (*_code == '0') {
				string[i] = '\0';
			} else {
				LexerError();
			};;;;;;
		} else {
			string[i] = *_code;
		};
		i = i + 1;
		advanceLexer(1);
	};
	token->string = String_init(string, i);
	if (*_code != '"') { LexerError(); };
	advanceLexer(1);
	Buffer_append((Void***)&_tokens, (Void*)token);
};

func lexCharacterLiteral() {
	if (*_code != '\'') { LexerError(); };
	var token = newToken();
	token->kind = .CharacterLiteral;
	token->pos = newSrcPos(_file, _start, _line, _column);
	advanceLexer(1);
	if (*_code == '\\') {
		advanceLexer(1);
		if (*_code == '\\') {
			token->string = String_init_literal("\\");
		} else if (*_code == '\'') {
			token->string = String_init_literal("\'");
		} else if (*_code == '"') {
			token->string = String_init_literal("\"");
		} else if (*_code == 'n') {
			token->string = String_init_literal("\n");
		} else if (*_code == 't') {
			token->string = String_init_literal("\t");
		} else if (*_code == '0') {
			token->string = String_init("\0", 1);
		} else {
			LexerError();
		};;;;;;
	} else {
		token->string = String_init(_code, 1);
	};
	advanceLexer(1);
	if (*_code != '\'') { LexerError(); };
	advanceLexer(1);
	Buffer_append((Void***)&_tokens, (Void*)token);
};

func lexIdentifier() {
	var token = newToken();
	var start = _code;
	token->pos = newSrcPos(_file, _start, _line, _column);
	while (isalnum(*_code) || *_code == '_') { advanceLexer(1); };
	token->string = String_init(start, (UInt)_code - (UInt)start);
	token->kind = .Identifier;
	Buffer_append((Void***)&_tokens, (Void*)token);
};
