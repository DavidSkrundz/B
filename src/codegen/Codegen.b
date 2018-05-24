func codegenInclude(file: UInt8*) {
	printf((char*)"#include <%s>%c", file, 10);
};

func codegenTypedef(name: UInt8*, type: UInt8*) {
	printf((char*)"typedef %s %s;%c", type, name, 10);
};

func CodegenBuiltins() {
	codegenInclude("ctype.h");
	codegenInclude("stdbool.h");
	codegenInclude("stdint.h");
	codegenInclude("stdio.h");
	codegenInclude("stdlib.h");
	codegenInclude("string.h");
	codegenInclude("unistd.h");
	printf((char*)"%c", 10);
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
	printf((char*)"%c", 10);
};

func Codegen() {
	CodegenBuiltins();
	CodegenDeclarationDeclarations();
	CodegenDeclarationDefinitions();
	CodegenDeclarationImplementations();
};
