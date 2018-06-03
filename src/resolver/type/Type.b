struct Type {
	var kind: TypeKind;
	var type: Void*;
};

struct TypeIdentifier {
	var name: UInt8*;
};

struct TypePointer {
	var base: Type*;
};

struct TypeFunction {
	var returnType: Type*;
	var argumentTypes: Type**;
	var isVariadic: Bool;
};

func newType(): Type* {
	return (Type*)xcalloc(1, sizeof(Type));
};

func newTypeIdentifier(): TypeIdentifier* {
	return (TypeIdentifier*)xcalloc(1, sizeof(TypeIdentifier));
};

func newTypePointer(): TypePointer* {
	return (TypePointer*)xcalloc(1, sizeof(TypePointer));
};

func newTypeFunction(): TypeFunction* {
	return (TypeFunction*)xcalloc(1, sizeof(TypeFunction));
};
