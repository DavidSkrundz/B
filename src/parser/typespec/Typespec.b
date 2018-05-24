struct Typespec {
	var kind: UInt;
	var spec: Void*;
};

struct TypespecPointer {
	var base: Typespec*;
};

struct TypespecIdentifier {
	var name: Identifier*;
};

func newTypespec(): Typespec* {
	return (Typespec*)xcalloc((UInt)1, sizeof(Typespec));
};

func newTypespecPointer(): TypespecPointer* {
	return (TypespecPointer*)xcalloc((UInt)1, sizeof(TypespecPointer));
};

func newTypespecIdentifier(): TypespecIdentifier* {
	return (TypespecIdentifier*)xcalloc((UInt)1, sizeof(TypespecIdentifier));
};
