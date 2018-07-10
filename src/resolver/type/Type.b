struct Type {
	var kind: TypeKind;
	var type: Void*;
};

struct TypeIdentifier {
	var name: String*;
};

func TypeIdentifier_init(name: String*): TypeIdentifier* {
	var type = (TypeIdentifier*)xcalloc(1, sizeof(TypeIdentifier));
	type->name = name;
	return type;
};

struct TypePointer {
	var base: Type*;
};

func TypePointer_init(base: Type*): TypePointer* {
	var type = (TypePointer*)xcalloc(1, sizeof(TypePointer));
	type->base = base;
	return type;
};

struct TypeFunction {
	var returnType: Type*;
	var argumentTypes: Type**;
	var isVariadic: Bool;
};

func newType(): Type* {
	return (Type*)xcalloc(1, sizeof(Type));
};

func newTypeFunction(): TypeFunction* {
	return (TypeFunction*)xcalloc(1, sizeof(TypeFunction));
};
