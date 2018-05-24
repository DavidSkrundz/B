func codegenTypeIdentifier(type: TypeIdentifier*) {
	printf((char*)"%s", type->name);
};

func codegenTypePointer(type: TypePointer*) {
	codegenType(type->base);
	printf((char*)"*");
};

func codegenType(type: Type*) {
	if (type->kind == TypeKind_Identifier) {
		codegenTypeIdentifier((TypeIdentifier*)type->type);
	} else if (type->kind == TypeKind_Pointer) {
		codegenTypePointer((TypePointer*)type->type);
	} else {
		fprintf(stderr, (char*)"Invalid type kind %zu%c", type->kind, 10);
		abort();
	};;
};
