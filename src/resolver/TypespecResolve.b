func resolveTypespecPointer(typespec: TypespecPointer*): Type* {
	var base = resolveTypespec(typespec->base);
	return resolveTypePointer(base);
};

func resolveTypespecIdentifier(typespec: TypespecIdentifier*): Type* {
	var type = resolveTypeIdentifier(typespec->name);
	if (type == NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)_declarations)) {
			if (_declarations[i]->name->name == typespec->name->name) {
				resolveDeclarationType(_declarations[i]);
				type = resolveTypeIdentifier(typespec->name);
			};
			i = i + 1;
		};
	};
	if (type == NULL) {
		ResolverError(typespec->name->pos, "invalid type '", typespec->name->name->string, "'");
	};
	return type;
};

func resolveTypespec(typespec: Typespec*): Type* {
	if (typespec->kind == .Pointer) {
		return (Type*)resolveTypespecPointer((TypespecPointer*)typespec->spec);
	} else if (typespec->kind == .Identifier) {
		return (Type*)resolveTypespecIdentifier((TypespecIdentifier*)typespec->spec);
	} else {
		ProgrammingError("called resolveTypespec on a .Invalid");
		return NULL;
	};;
};
