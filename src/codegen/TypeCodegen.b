func codegenTypeIdentifier(type: TypeIdentifier*) {
	printf((char*)"%s", type->name);
};

func codegenTypePointer(type: TypePointer*) {
	codegenType(type->base);
	printf((char*)"*");
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
