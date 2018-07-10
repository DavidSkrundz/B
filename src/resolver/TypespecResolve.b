func resolveTypespecPointer(typespec: TypespecPointer*): Type* {
	var base = resolveTypespec(typespec->base);
	return resolveTypePointer(base);
};

func resolveTypespecIdentifier(typespec: TypespecIdentifier*): Type* {
	var type = resolveTypeIdentifier(typespec->name->string);
	if (type == NULL) {
		ResolverError(typespec->name->pos, "invalid type '", typespec->name->string->string, "'");
	};
	return type;
};

func resolveTypespec(typespec: Typespec*): Type* {
	if (typespec->kind == .Pointer) {
		return resolveTypespecPointer((TypespecPointer*)typespec->spec);
	} else if (typespec->kind == .Identifier) {
		return resolveTypespecIdentifier((TypespecIdentifier*)typespec->spec);
	} else {
		ProgrammingError("called resolveTypespec on a .Invalid");
		return NULL;
	};;
};
