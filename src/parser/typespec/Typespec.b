struct Typespec {
	var pos: SrcPos*;
	var kind: TypespecKind;
	var spec: Void*;
};

struct TypespecPointer {
	var base: Typespec*;
};

struct TypespecIdentifier {
	var name: Identifier*;
};

func newTypespec(): Typespec* {
	return (Typespec*)xcalloc(1, sizeof(Typespec));
};

func newTypespecPointer(): TypespecPointer* {
	return (TypespecPointer*)xcalloc(1, sizeof(TypespecPointer));
};

func newTypespecIdentifier(): TypespecIdentifier* {
	return (TypespecIdentifier*)xcalloc(1, sizeof(TypespecIdentifier));
};
