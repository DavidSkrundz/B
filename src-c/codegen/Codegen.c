#include "Codegen.h"

#include <stdio.h>

#include "DeclarationCodegen.h"

void codegenInclude(char* file) {
	printf("#include <%s>\n", file);
}

void codegenTypedef(char* name, char* type) {
	printf("typedef %s %s;\n", type, name);
}

void CodegenBuiltins(void) {
	codegenInclude("ctype.h");
	codegenInclude("stdbool.h");
	codegenInclude("stdint.h");
	codegenInclude("stdio.h");
	codegenInclude("stdlib.h");
	codegenInclude("string.h");
	codegenInclude("unistd.h");
	printf("\n");
	codegenTypedef("Void", "void");
	codegenTypedef("Bool", "bool");
	codegenTypedef("Int", "ssize_t");
	codegenTypedef("UInt", "size_t");
	codegenTypedef("Int8", "int8_t");
	codegenTypedef("UInt8", "uint8_t");
	codegenTypedef("Int16", "int16_t");
	codegenTypedef("UInt16", "uint16_t");
	codegenTypedef("Int32", "int32_t");
	codegenTypedef("UInt32", "uint32_t");
	codegenTypedef("Int64", "int64_t");
	codegenTypedef("UInt64", "uint64_t");
	printf("\n");
}

void Codegen(void) {
	CodegenBuiltins();
	CodegenDeclarationDeclarations();
	CodegenDeclarationDefinitions();
	CodegenDeclarationImplementations();
}
