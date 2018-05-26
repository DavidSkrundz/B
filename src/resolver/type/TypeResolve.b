func isPointer(type: Type*): Bool {
	return type->kind == TypeKind_Pointer;
};

func getPointerBase(type: Type*): Type* {
	if (type->kind == TypeKind_Identifier) {
		fprintf(stderr, (char*)"Not a pointer%c", 10);
		abort();
	} else if (type->kind == TypeKind_Pointer) {
		var pointer = (TypePointer*)type->type;
		return pointer->base;
	} else if (type->kind == TypeKind_Function) {
		fprintf(stderr, (char*)"Not a pointer%c", 10);
		abort();
	} else {
		fprintf(stderr, (char*)"Invalid type kind %zu%c", type->kind, 10);
		exit(EXIT_FAILURE);
	};;;
};

func registerType(type: Type*) {
	if (_typeCount == MAX_TYPE_COUNT) {
		fprintf(stderr, (char*)"Too many types are defined%c", 10);
		exit(EXIT_FAILURE);
	};
	_types[_typeCount] = type;
	_typeCount = _typeCount + 1;
};

func resolveTypeIdentifier(name: Identifier*): Type* {
	var i = 0;
	while (i < _typeCount) {
		var type = _types[i];
		if (type->kind == TypeKind_Identifier) {
			var identifier = (TypeIdentifier*)type->type;
			if (name->length == strlen((char*)identifier->name)) {
				if (strncmp((char*)identifier->name, (char*)name->name, name->length) == (int)0) {
					return type;
				};
			};
		};
		i = i + 1;
	};
	return NULL;
};

func resolveTypePointer(base: Type*): Type* {
	var i = 0;
	while (i < _typeCount) {
		var type = _types[i];
		if (type->kind == TypeKind_Pointer) {
			var pointer = (TypePointer*)type->type;
			if (pointer->base == base) { return type; };
		};
		i = i + 1;
	};
	return NULL;
};

func resolveTypeFunction(returnType: Type*, argumentTypes: Type**, argumentCount: UInt, isVariadic: Bool): Type* {
	var i = 0;
	while (i < _typeCount) {
		var type = _types[i];
		if (type->kind == TypeKind_Function) {
			var funcType = (TypeFunction*)type->type;
			if (funcType->isVariadic == isVariadic) {
				if (funcType->returnType == returnType) {
					if (funcType->count == argumentCount) {
						var isMatch = true;
						var j = 0;
						while (j < argumentCount) {
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
	identifier->name = name;
	identifier->length = strlen((char*)name);
	return createTypeIdentifier(identifier);
};

func createTypeIdentifier(name: Identifier*): Type* {
	if (resolveTypeIdentifier(name) != NULL) {
		fprintf(stderr, (char*)"Type already exists: %.*s%c", (int)name->length, name->name, 10);
		exit(EXIT_FAILURE);
	};
	var typeIdentifier = newTypeIdentifier();
	typeIdentifier->name = (UInt8*)strndup((char*)name->name, name->length);
	var type = newType();
	type->kind = TypeKind_Identifier;
	type->type = (Void*)typeIdentifier;
	registerType(type);
	return type;
};

func createTypePointer(base: Type*): Type* {
	if (resolveTypePointer(base) != NULL) {
		fprintf(stderr, (char*)"Pointer type already created%c", 10);
		abort();
	};
	var typePointer = newTypePointer();
	typePointer->base = base;
	var type = newType();
	type->kind = TypeKind_Pointer;
	type->type = (Void*)typePointer;
	registerType(type);
	return type;
};

func createTypeFunction(returnType: Type*, argumentTypes: Type**, argumentCount: UInt, isVariadic: Bool): Type* {
	if (resolveTypeFunction(returnType, argumentTypes, argumentCount, isVariadic) != NULL) {
		fprintf(stderr, (char*)"Function type already created%c", 10);
		abort();
	};
	var funcType = newTypeFunction();
	funcType->returnType = returnType;
	funcType->argumentTypes = argumentTypes;
	funcType->count = argumentCount;
	funcType->isVariadic = isVariadic;
	var type = newType();
	type->kind = TypeKind_Function;
	type->type = (Void*)funcType;
	registerType(type);
	return type;
};
