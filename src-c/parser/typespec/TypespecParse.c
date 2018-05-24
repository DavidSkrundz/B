#include "TypespecParse.h"

#include <stdlib.h>

#include "TypespecKind.h"
#include "../../lexer/token/TokenKind.h"
#include "../identifier/IdentifierParse.h"

TypespecIdentifier* parseTypespecIdentifier(Token*** tokens) {
	TypespecIdentifier* typespecIdentifier = newTypespecIdentifier();
	typespecIdentifier->name = parseIdentifier(tokens);
	if (typespecIdentifier->name == NULL) { return NULL; }
	return typespecIdentifier;
}

Typespec* parseTypespec(Token*** tokens) {
	Typespec* typespec = newTypespec();
	if ((**tokens)->kind == TokenKind_Identifier) {
		typespec->kind = TypespecKind_Identifier;
		typespec->spec = parseTypespecIdentifier(tokens);
	} else { return NULL; }
	while ((**tokens)->kind == TokenKind_Star) {
		++(*tokens);
		TypespecPointer* typespecPointer = newTypespecPointer();
		typespecPointer->base = typespec;
		typespec = newTypespec();
		typespec->kind = TypespecKind_Pointer;
		typespec->spec = typespecPointer;
	}
	return typespec;
}
