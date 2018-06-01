func resolveTypespecPointer(typespec: TypespecPointer*): Type* {
	var base = resolveTypespec(typespec->base);
	return resolveTypePointer(base);
};

func resolveTypespecIdentifier(typespec: TypespecIdentifier*): Type* {
	var type = resolveTypeIdentifier(typespec->name);
	if (type == NULL) {
		var i = 0;
		while (i < bufferCount((Void**)_declarations)) {
			if (_declarations[i]->name->length == typespec->name->length) {
				if (strncmp((char*)_declarations[i]->name->name, (char*)typespec->name->name, typespec->name->length) == (int)0) {
					resolveDeclarationType(_declarations[i]);
					type = resolveTypeIdentifier(typespec->name);
				};
			};
			i = i + 1;
		};
	};
	if (type == NULL) {
		fprintf(stderr, (char*)"Invalid type '%.*s'%c", (int)typespec->name->length, typespec->name->name, 10);
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
		fprintf(stderr, (char*)"Invalid typespec kind %u%c", typespec->kind, 10);
		abort();
	};;
};
