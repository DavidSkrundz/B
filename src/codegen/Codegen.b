func codegenInclude(file: UInt8*) {
	printf((char*)"#include <%s>\n", file);
};

func codegenTypedef(name: UInt8*, type: UInt8*) {
	printf((char*)"typedef %s %s;\n", type, name);
};

func CodegenBuiltins() {
	codegenInclude("stdbool.h");
	codegenInclude("stddef.h");
	codegenInclude("stdint.h");
	codegenInclude("unistd.h");
	printf((char*)"\n");
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
	printf((char*)"\n");
};

var Attribute_Foreign: String*;
func CodegenForeignImports() {
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		if (_declarations[i]->attribute != NULL) {
			if (_declarations[i]->attribute->name->name == Attribute_Foreign) {
				if (Buffer_getCount((Void**)_declarations[i]->attribute->parameters) == 2) {
					printf((char*)"#include <%s.h>\n", _declarations[i]->attribute->parameters[1]->name->string);
				};
			};
		};
		i = i + 1;
	};
	printf((char*)"\n");
};

func Codegen() {
	Attribute_Foreign = String_init_literal("foreign");
	
	CodegenBuiltins();
	CodegenForeignImports();
	CodegenDeclarationDeclarations();
	CodegenDeclarationDefinitions();
	CodegenDeclarationImplementations();
};
