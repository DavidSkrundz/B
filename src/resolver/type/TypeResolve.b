var _types: Type**;

func isPointer(type: Type*): Bool {
	return type->kind == .Pointer;
};

func getPointerBase(type: Type*): Type* {
	if (type->kind == .Identifier) {
		fprintf(stderr, (char*)"Not a pointer\n");
		abort();
	} else if (type->kind == .Pointer) {
		var pointer = (TypePointer*)type->type;
		return pointer->base;
	} else if (type->kind == .Function) {
		fprintf(stderr, (char*)"Not a pointer\n");
		abort();
	} else {
		fprintf(stderr, (char*)"Invalid type kind %u\n", type->kind);
		exit(EXIT_FAILURE);
	};;;
};

func registerType(type: Type*) {
	append((Void***)&_types, (Void*)type);
};

func resolveTypeIdentifier(name: Identifier*): Type* {
	var i = 0;
	while (i < bufferCount((Void**)_types)) {
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
	while (i < bufferCount((Void**)_types)) {
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
	while (i < bufferCount((Void**)_types)) {
		var type = _types[i];
		if (type->kind == .Function) {
			var funcType = (TypeFunction*)type->type;
			if (funcType->isVariadic == isVariadic) {
				if (funcType->returnType == returnType) {
					if (bufferCount((Void**)funcType->argumentTypes) == bufferCount((Void**)argumentTypes)) {
						var isMatch = true;
						var j = 0;
						while (j < bufferCount((Void**)funcType->argumentTypes)) {
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
	return createTypeIdentifier(identifier);
};

func createTypeIdentifier(name: Identifier*): Type* {
	if (resolveTypeIdentifier(name) != NULL) {
		fprintf(stderr, (char*)"Type already exists: %s\n", name->name);
		exit(EXIT_FAILURE);
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
		fprintf(stderr, (char*)"Function type already created\n");
		abort();
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
