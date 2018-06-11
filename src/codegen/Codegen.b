func codegenInclude(file: UInt8*) {
	printf((char*)"#include <%s>%c", file, 10);
};

func codegenTypedef(name: UInt8*, type: UInt8*) {
	printf((char*)"typedef %s %s;%c", type, name, 10);
};

func CodegenBuiltins() {
	codegenInclude("stdbool.h");
	codegenInclude("stddef.h");
	codegenInclude("stdint.h");
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

var Attribute_Foreign: UInt8*;
func CodegenForeignImports() {
	var i = 0;
	while (i < bufferCount((Void**)_declarations)) {
		if (_declarations[i]->attribute != NULL) {
			if (_declarations[i]->attribute->name->name == Attribute_Foreign) {
				if (bufferCount((Void**)_declarations[i]->attribute->parameters) == 2) {
					printf((char*)"#include <%s.h>%c", _declarations[i]->attribute->parameters[1]->name, 10);
				};
			};
		};
		i = i + 1;
	};
	printf((char*)"%c", 10);
};

func Codegen() {
	Attribute_Foreign = internLiteral("foreign");
	
	CodegenBuiltins();
	CodegenForeignImports();
	CodegenDeclarationDeclarations();
	CodegenDeclarationDefinitions();
	CodegenDeclarationImplementations();
};
