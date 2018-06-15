func printTypespec(typespec: Typespec*) {
	printf((char*)"(type ");
	if (typespec->kind == .Pointer) {
		printTypespecPointer((TypespecPointer*)typespec->spec);
	} else if (typespec->kind == .Identifier) {
		printTypespecIdentifier((TypespecIdentifier*)typespec->spec);
	} else {
		fprintf(stderr, (char*)"Invalid typespec kind %u%c", typespec->kind, '\n');
		abort();
	};;
	printf((char*)")");
};

func printTypespecPointer(typespec: TypespecPointer*) {
	printf((char*)"(pointer ");
	if (typespec->base->kind == .Pointer) {
		printTypespecPointer((TypespecPointer*)typespec->base->spec);
	} else if (typespec->base->kind == .Identifier) {
		printTypespecIdentifier((TypespecIdentifier*)typespec->base->spec);
	} else {
		fprintf(stderr, (char*)"Invalid typespec kind %u%c", typespec->base->kind, '\n');
		abort();
	};;
	printf((char*)")");
};

func printTypespecIdentifier(typespec: TypespecIdentifier*) {
	printIdentifier(typespec->name);
};
