#include "Lexer.h"

#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../utility/Memory.h"
#include "token/TokenKind.h"
#include "token/TokenPrint.h"

Token** tokens = NULL;
int tokenCount = 0;

#define CASE1(SYMBOL, TOKEN) \
	case SYMBOL: \
		token = newToken(); \
		token->kind = TOKEN; \
		token->value = code++; \
		token->length = 1; \
		tokens[tokenCount++] = token; \
		break;

#define CASE2(SYMBOL1, TOKEN1, SYMBOL2, TOKEN2) \
	case SYMBOL1: \
		token = newToken(); \
		token->kind = TOKEN1; \
		token->value = code++; \
		token->length = 1; \
		if (*code == SYMBOL2) { \
			++code; \
			token->kind = TOKEN2; \
			token->length = 2; \
		} \
		tokens[tokenCount++] = token; \
		break;

void Lex(char* code, int codeLength) {
	InitTokenKinds();
	
	tokens = xcalloc(codeLength, sizeof(Token*));
	tokenCount = 0;
	
	while (true) {
		Token* token = NULL;
		switch (*code) {
			case ' ':
			case '\t':
			case '\n':
				while (isspace(*(++code))) {}
				break;
			
			CASE1(',', TokenKind_Comma)
			CASE1(':', TokenKind_Colon)
			CASE1(';', TokenKind_Semicolon)
			CASE1('{', TokenKind_OpenCurly)
			CASE1('}', TokenKind_CloseCurly)
			CASE1('[', TokenKind_OpenBracket)
			CASE1(']', TokenKind_CloseBracket)
			CASE1('(', TokenKind_OpenParenthesis)
			CASE1(')', TokenKind_CloseParenthesis)
			
			CASE1('@', TokenKind_At)
			CASE1('*', TokenKind_Star)
			CASE2('&', TokenKind_And, '&', TokenKind_AndAnd)
			CASE2('|', TokenKind_Invalid, '|', TokenKind_OrOr)
			
			CASE1('+', TokenKind_Plus)
			CASE2('-', TokenKind_Minus, '>', TokenKind_Arrow)
			CASE1('/', TokenKind_Slash)
			CASE2('!', TokenKind_Not, '=', TokenKind_NotEqual)
			CASE2('=', TokenKind_Assign, '=', TokenKind_Equal)
			CASE1('<', TokenKind_LessThan)
			
			case '.':
				if (code[1] == '.' && code[2] == '.') {
					token = newToken();
					token->kind = TokenKind_Ellipses;
					token->value = code;
					token->length = 3;
					tokens[tokenCount++] = token;
					code += 3;
				}
				break;
			
			case '"':
				token = newToken();
				token->kind = TokenKind_StringLiteral;
				token->value = ++code;
				while (*code != '"' && *code != '\\' && isprint(*code)) { ++code; }
				token->length = (int)(code++ - token->value);
				tokens[tokenCount++] = token;
				break;
			
			case '0': case '1': case '2': case '3': case '4': case '5':
			case '6': case '7': case '8': case '9':
				token = newToken();
				token->kind = TokenKind_IntegerLiteral;
				token->value = code;
				while (isdigit(*code)) { ++code; }
				token->length = (int)(code - token->value);
				tokens[tokenCount++] = token;
				break;
			
			case 'a': case 'b': case 'c': case 'd': case 'e': case 'f':
			case 'g': case 'h': case 'i': case 'j': case 'k': case 'l':
			case 'm': case 'n': case 'o': case 'p': case 'q': case 'r':
			case 's': case 't': case 'u': case 'v': case 'w': case 'x':
			case 'y': case 'z':
			case 'A': case 'B': case 'C': case 'D': case 'E': case 'F':
			case 'G': case 'H': case 'I': case 'J': case 'K': case 'L':
			case 'M': case 'N': case 'O': case 'P': case 'Q': case 'R':
			case 'S': case 'T': case 'U': case 'V': case 'W': case 'X':
			case 'Y': case 'Z':
			case '_':
				token = newToken();
				token->value = code;
				while (isalnum(*code) || *code == '_') { ++code; }
				token->length = (int)(code - token->value);
				if (token->length == 4 && strncmp(token->value, "NULL", token->length) == 0) {
					token->kind = TokenKind_NULL;
				} else if (token->length == 6 && strncmp(token->value, "sizeof",  token->length) == 0) {
					token->kind = TokenKind_Sizeof;
				} else if (token->length == 3 && strncmp(token->value, "var",  token->length) == 0) {
					token->kind = TokenKind_Var;
				} else if (token->length == 4 && strncmp(token->value, "func",  token->length) == 0) {
					token->kind = TokenKind_Func;
				} else if (token->length == 6 && strncmp(token->value, "struct", token->length) == 0) {
					token->kind = TokenKind_Struct;
				} else if (token->length == 2 && strncmp(token->value, "if", token->length) == 0) {
					token->kind = TokenKind_If;
				} else if (token->length == 4 && strncmp(token->value, "else", token->length) == 0) {
					token->kind = TokenKind_Else;
				} else if (token->length == 5 && strncmp(token->value, "while", token->length) == 0) {
					token->kind = TokenKind_While;
				} else if (token->length == 6 && strncmp(token->value, "return",  token->length) == 0) {
					token->kind = TokenKind_Return;
				} else if (token->length == 4 && strncmp(token->value, "true",  token->length) == 0) {
					token->kind = TokenKind_BooleanLiteral;
				} else if (token->length == 5 && strncmp(token->value, "false",  token->length) == 0) {
					token->kind = TokenKind_BooleanLiteral;
				} else {
					token->kind = TokenKind_Identifier;
				}
				tokens[tokenCount++] = token;
				break;
			
			case '\0':
				token = newToken();
				token->kind = TokenKind_EOF;
				token->value = code++;
				token->length = 1;
				tokens[tokenCount++] = token;
				return;
			
			default:
				printTokens(tokens, tokenCount);
				if (isprint(*code)) {
					fprintf(stderr, "Unexpected character: '%c'\n", *code);
				} else {
					fprintf(stderr, "Unexpected character: %02X\n", *code);
				}
				exit(EXIT_FAILURE);
		}
	}
}
