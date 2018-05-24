func printTypespec(typespec: Typespec*) {
	printf((char*)"(type ");
	if (typespec->kind == TypespecKind_Pointer) {
		printTypespecPointer((TypespecPointer*)typespec->spec);
	} else if (typespec->kind == TypespecKind_Identifier) {
		printTypespecIdentifier((TypespecIdentifier*)typespec->spec);
	} else {
		fprintf(stderr, (char*)"Invalid typespec kind %zu%c", typespec->kind, 10);
		abort();
	};;
	printf((char*)")");
};

func printTypespecPointer(typespec: TypespecPointer*) {
	printf((char*)"(pointer ");
	if (typespec->base->kind == TypespecKind_Pointer) {
		printTypespecPointer((TypespecPointer*)typespec->base->spec);
	} else if (typespec->base->kind == TypespecKind_Identifier) {
		printTypespecIdentifier((TypespecIdentifier*)typespec->base->spec);
	} else {
		fprintf(stderr, (char*)"Invalid typespec kind %zu%c", typespec->base->kind, 10);
		abort();
	};;
	printf((char*)")");
};

func printTypespecIdentifier(typespec: TypespecIdentifier*) {
	printIdentifier(typespec->name);
};
