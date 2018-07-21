var _code: UInt8*;
var _codeLength = 0;

var _tokens: Token**;

var _file: UInt8*;
var _start: UInt8*;
var _line = 0;
var _column = 0;

func charToTokenKind(character: UInt8): TokenKind {
	if (character == '\0') {       return .EOF;
	} else if (character == ',') { return .Comma;
	} else if (character == ':') { return .Colon;
	} else if (character == ';') { return .Semicolon;
	} else if (character == '{') { return .OpenCurly;
	} else if (character == '}') { return .CloseCurly;
	} else if (character == '[') { return .OpenBracket;
	} else if (character == ']') { return .CloseBracket;
	} else if (character == '(') { return .OpenParenthesis;
	} else if (character == ')') { return .CloseParenthesis;
	} else if (character == '?') { return .Question;
	} else if (character == '+') { return .Plus;
	} else if (character == '*') { return .Star;
	} else if (character == '/') { return .Slash;
	} else if (character == '^') { return .Xor;
	} else if (character == '@') { return .At;
	} else {                    return .Invalid;
	};;;;;;;;;;;;;;;;
};

func isCharToken(character: UInt8): Bool {
	return charToTokenKind(character) != .Invalid;
};

func char2ToTokenKind(character1: UInt8, character2: UInt8): TokenKind {
	if (character1 == '-') {
		if (character2 == '>') { return .Arrow; };
		return .Minus;
	} else if (character1 == '|') {
		if (character2 == '|') { return .OrOr; };
		return .Or;
	} else if (character1 == '&') {
		if (character2 == '&') { return .AndAnd; };
		return .And;
	} else if (character1 == '<') {
		if (character2 == '<') { return .LeftShift; };
		if (character2 == '=') { return .LessThanEqual; };
		return .LessThan;
	} else if (character1 == '>') {
		if (character2 == '>') { return .RightShift; };
		if (character2 == '=') { return .GreaterThanEqual; };
		return .GreaterThan;
	} else if (character1 == '!') {
		if (character2 == '=') { return .NotEqual; };
		return .Not;
	} else if (character1 == '=') {
		if (character2 == '=') { return .Equal; };
		return .Assign;
	};;;;;;;
	return .Invalid;
};

func char2TokenLength(character1: UInt8, character2: UInt8): UInt {
	if (character1 == '-') {
		if (character2 == '>') { return 2; };
		return 1;
	} else if (character1 == '|') {
		if (character2 == '|') { return 2; };
		return 1;
	} else if (character1 == '&') {
		if (character2 == '&') { return 2; };
		return 1;
	} else if (character1 == '<') {
		if (character2 == '<') { return 2; };
		if (character2 == '=') { return 2; };
		return 1;
	} else if (character1 == '>') {
		if (character2 == '>') { return 2; };
		if (character2 == '=') { return 2; };
		return 1;
	} else if (character1 == '!') {
		if (character2 == '=') { return 2; };
		return 1;
	} else if (character1 == '=') {
		if (character2 == '=') { return 2; };
		return 1;
	};;;;;;;
	return 0;
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
		} else if (*_code == '\0') {
			return lexToken1();
		} else if (isCharToken(*_code)) {
			lexToken1();
		} else if (0 < char2TokenLength(*_code, '\0')) {
			lexToken2();
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
		} else {
			LexerError();
		};;;;;;;;;;;
	};
};

func nextCode(): UInt8* {
	return (UInt8*)((UInt)_code + sizeof(UInt8));
};

func advanceLexer(amount: UInt) {
	_column = _column + amount;
	_code = (UInt8*)((UInt)_code + amount * sizeof(UInt8));
};

func lexToken1() {
	var token = newToken();
	token->kind = charToTokenKind(*_code);
	token->pos = newSrcPos(_file, _start, _line, _column);
	token->string = String_init(_code, 1);
	advanceLexer(1);
	Buffer_append((Void***)&_tokens, (Void*)token);
};

func lexToken2() {
	var token = newToken();
	token->kind = char2ToTokenKind(*_code, *nextCode());
	token->pos = newSrcPos(_file, _start, _line, _column);
	var start = _code;
	var length = char2TokenLength(*_code, *nextCode());
	advanceLexer(length);
	token->string = String_init(start, length);
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
