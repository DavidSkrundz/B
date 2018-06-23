var _types: Type**;

func isPointer(type: Type*): Bool {
	return type->kind == .Pointer;
};

func getPointerBase(type: Type*): Type* {
	if (type->kind == .Identifier) {
		ProgrammingError("called getPointerBase on a .Identifier");
	} else if (type->kind == .Pointer) {
		var pointer = (TypePointer*)type->type;
		return pointer->base;
	} else if (type->kind == .Function) {
		ProgrammingError("called getPointerBase on a .Function");
	} else {
		ProgrammingError("called getPointerBase on a .Invalid");
	};;;
	return NULL;
};

func registerType(type: Type*) {
	Buffer_append((Void***)&_types, (Void*)type);
};

func resolveTypeIdentifier(name: Identifier*): Type* {
	var i = 0;
	while (i < Buffer_getCount((Void**)_types)) {
		var type = _types[i];
		if (type->kind == .Identifier) {
			var identifier = (TypeIdentifier*)type->type;
			if (identifier->name == name->name) {
				return type;
			};
		};
		i = i + 1;
	};
	return NULL;
};

func resolveTypePointer(base: Type*): Type* {
	var i = 0;
	while (i < Buffer_getCount((Void**)_types)) {
		var type = _types[i];
		if (type->kind == .Pointer) {
			var pointer = (TypePointer*)type->type;
			if (pointer->base == base) { return type; };
		};
		i = i + 1;
	};
	var typePointer = newTypePointer();
	typePointer->base = base;
	var type = newType();
	type->kind = .Pointer;
	type->type = (Void*)typePointer;
	registerType(type);
	return type;
};

func resolveTypeFunction(returnType: Type*, argumentTypes: Type**, isVariadic: Bool): Type* {
	var i = 0;
	while (i < Buffer_getCount((Void**)_types)) {
		var type = _types[i];
		if (type->kind == .Function) {
			var funcType = (TypeFunction*)type->type;
			if (funcType->isVariadic == isVariadic) {
				if (funcType->returnType == returnType) {
					if (Buffer_getCount((Void**)funcType->argumentTypes) == Buffer_getCount((Void**)argumentTypes)) {
						var isMatch = true;
						var j = 0;
						while (j < Buffer_getCount((Void**)funcType->argumentTypes)) {
							if (funcType->argumentTypes[j] != argumentTypes[j]) {
								isMatch = false;
							};
							j = j + 1;
						};
						if (isMatch) { return type; };
					};
				};
			};
		};
		i = i + 1;
	};
	return NULL;
};

func createTypeIdentifierString(name: UInt8*): Type* {
	var identifier = newIdentifier();
	identifier->pos = newSrcPos("builtin", "builtin", 0, 0);
	identifier->name = name;
	return createTypeIdentifier(identifier);
};

func createTypeIdentifier(name: Identifier*): Type* {
	if (resolveTypeIdentifier(name) != NULL) {
		ResolverError(name->pos, "duplicate definition of type '", name->name, "'");
	};
	var typeIdentifier = newTypeIdentifier();
	typeIdentifier->name = name->name;
	var type = newType();
	type->kind = .Identifier;
	type->type = (Void*)typeIdentifier;
	registerType(type);
	return type;
};

func createTypeFunction(returnType: Type*, argumentTypes: Type**, isVariadic: Bool): Type* {
	if (resolveTypeFunction(returnType, argumentTypes, isVariadic) != NULL) {
		ProgrammingError("attempting to create duplicate function type");
	};
	var funcType = newTypeFunction();
	funcType->returnType = returnType;
	funcType->argumentTypes = argumentTypes;
	funcType->isVariadic = isVariadic;
	var type = newType();
	type->kind = .Function;
	type->type = (Void*)funcType;
	registerType(type);
	return type;
};
