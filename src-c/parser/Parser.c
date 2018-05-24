#include "Parser.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "../lexer/Lexer.h"
#include "typespec/TypespecKind.h"
#include "declaration/DeclarationKind.h"
#include "declaration/DeclarationState.h"
#include "declaration/DeclarationPrint.h"
#include "declaration/DeclarationParse.h"
#include "statement/StatementKind.h"
#include "expression/ExpressionKind.h"
#include "../lexer/token/TokenKind.h"
#include "../lexer/token/TokenPrint.h"
#include "../utility/Memory.h"

Declaration** declarations = NULL;
int declarationCount = 0;

void Parse(void) {
	InitTypespecKinds();
	InitDeclarationKinds();
	InitDeclarationStates();
	InitStatementKinds();
	InitExpressionKinds();
	
	declarations = xcalloc(tokenCount, sizeof(Declaration*));
	declarationCount = 0;
	
	Token*** t = &tokens;
	while (true) {
		Declaration* declaration = parseDeclaration(t);
		if (declaration == NULL) { break; }
		declarations[declarationCount++] = declaration;
	}
	
	if ((*tokens)->kind != TokenKind_EOF) {
		fprintf(stderr, "Unexpected token: ");
		printToken_error(*tokens);
		fprintf(stderr, "\n\n");
		printDeclarations(declarations, declarationCount);
		exit(EXIT_FAILURE);
	}
}
