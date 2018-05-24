#include <stdio.h>
#include <stdlib.h>

#include "utility/File.h"
#include "lexer/Lexer.h"
#include "lexer/token/TokenPrint.h"
#include "parser/Parser.h"
#include "parser/declaration/DeclarationPrint.h"
#include "resolver/Resolver.h"
#include "codegen/Codegen.h"

void bmain(char** files, int fileCount, uint8_t flags) {
	char* code;
	int codeLength = readFiles(files, fileCount, &code);
	
	Lex(code, codeLength);
	if (flags & 1) { printTokens(tokens, tokenCount); }
	flags >>= 1;
	if (!flags) { return; }
	
	Parse();
	if (flags & 1) { printDeclarations(declarations, declarationCount); }
	flags >>= 1;
	if (!flags) { return; }
	
	Resolve();
	flags >>= 1;
	if (!flags) { return; }
	
	Codegen();
}

void printUsage(char* self) {
	printf("Usage: %s <option> file...\n", self);
	printf("Options:\n");
	printf("  -l                       Lex and output tokens\n");
	printf("  -p                       Parse and output ast\n");
	printf("  -r                       Resolve and output errors\n");
	printf("  -g                       Codegen and output C\n");
	exit(EXIT_FAILURE);
}

int main(int argc, char** argv) {
	if (argc < 3) { printUsage(argv[0]); }
	if (argv[1][0] != '-') { printUsage(argv[0]); }
	if (argv[1][2] != '\0') { printUsage(argv[0]); }
	
	uint8_t flags = 0;
	switch (argv[1][1]) {
		case 'l': flags |= 1 << 0; break;
		case 'p': flags |= 1 << 1; break;
		case 'r': flags |= 1 << 2; break;
		case 'g': flags |= 1 << 3; break;
		default: printUsage(argv[0]);
	}
	bmain(&argv[2], argc-2, flags);
	
	exit(EXIT_SUCCESS);
}
