func resolveTypespecPointer(typespec: TypespecPointer*): Type* {
	var base = resolveTypespec(typespec->base);
	return resolveTypePointer(base);
};

func resolveTypespecIdentifier(typespec: TypespecIdentifier*): Type* {
	var type = resolveTypeIdentifier(typespec->name);
	if (type == NULL) {
		var i = 0;
		while (i < bufferCount((Void**)_declarations)) {
			if (_declarations[i]->name->name == typespec->name->name) {
				resolveDeclarationType(_declarations[i]);
				type = resolveTypeIdentifier(typespec->name);
			};
			i = i + 1;
		};
	};
	if (type == NULL) {
		fprintf(stderr, (char*)"Invalid type '%s'\n", typespec->name->name);
		exit(EXIT_FAILURE);
	};
	return type;
};

func resolveTypespec(typespec: Typespec*): Type* {
	if (typespec->kind == .Pointer) {
		return (Type*)resolveTypespecPointer((TypespecPointer*)typespec->spec);
	} else if (typespec->kind == .Identifier) {
		return (Type*)resolveTypespecIdentifier((TypespecIdentifier*)typespec->spec);
	} else {
		fprintf(stderr, (char*)"Invalid typespec kind %u\n", typespec->kind);
		abort();
	};;
};
