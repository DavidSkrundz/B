func printTypespec(typespec: Typespec*) {
	printf((char*)"(type ");
	if (typespec->kind == .Pointer) {
		printTypespecPointer((TypespecPointer*)typespec->spec);
	} else if (typespec->kind == .Identifier) {
		printTypespecIdentifier((TypespecIdentifier*)typespec->spec);
	} else {
		fprintf(stderr, (char*)"Invalid typespec kind %u\n", typespec->kind);
		Abort();
	};;
	printf((char*)")");
};

func printTypespecPointer(typespec: TypespecPointer*) {
	printf((char*)"(pointer ");
	if (typespec->base->kind == .Pointer) {
		printTypespecPointer((TypespecPointer*)typespec->base->spec);
	} else if (typespec->base->kind == .Identifier) {
		printTypespecIdentifier((TypespecIdentifier*)typespec->base->spec);
	} else if (typespec->base->kind == .Invalid) {
		fprintf(stderr, (char*)"Invalid typespec kind %u\n", typespec->base->kind);
		Abort();
	} else {
		fprintf(stderr, (char*)"Invalid typespec kind %u\n", typespec->base->kind);
		Abort();
	};;;
	printf((char*)")");
};

func printTypespecIdentifier(typespec: TypespecIdentifier*) {
	printIdentifier(typespec->name);
};
