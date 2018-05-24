#include "IdentifierParse.h"

#include <stdio.h>

#include "../../lexer/token/TokenKind.h"

Identifier* parseIdentifier(Token*** tokens) {
	if ((**tokens)->kind != TokenKind_Identifier) { return NULL; }
	Identifier* identifier = newIdentifier();
	identifier->name = (**tokens)->value;
	identifier->length = (**tokens)->length;
	++(*tokens);
	return identifier;
}
