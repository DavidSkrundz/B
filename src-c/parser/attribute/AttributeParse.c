#include "AttributeParse.h"

#include <stdlib.h>

#include "../../lexer/token/TokenKind.h"
#include "../identifier/IdentifierParse.h"

Attribute* parseAttribute(Token*** tokens) {
	if ((**tokens)->kind != TokenKind_At) { return NULL; }
	++(*tokens);
	Attribute* attribute = newAttribute();
	attribute->name = parseIdentifier(tokens);
	return attribute;
}
