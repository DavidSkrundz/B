func codegenTypeIdentifier(type: TypeIdentifier*) {
	String_print(stdout, type->name);
};

func codegenTypePointer(type: TypePointer*) {
	codegenType(type->base);
	printf((char*)"*");
};

func codegenSymbolType(symbol: Symbol*) {
	codegenType(symbol->type);
};

func codegenType(type: Type*) {
	if (type->kind == .Identifier) {
		codegenTypeIdentifier((TypeIdentifier*)type->type);
	} else if (type->kind == .Pointer) {
		codegenTypePointer((TypePointer*)type->type);
	} else {
		ProgrammingError("called codegenType on a .Invalid");
	};;
};
