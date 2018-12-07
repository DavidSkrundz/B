struct Typespec {
	var pos: SrcPos*;
	var kind: TypespecKind;
	var spec: Void*;
};

struct TypespecPointer {
	var base: Typespec*;
};

struct TypespecIdentifier {
	var name: Token*;
};

func newTypespec(): Typespec* {
	return (Typespec*)Calloc(1, sizeof(Typespec));
};

func newTypespecPointer(): TypespecPointer* {
	return (TypespecPointer*)Calloc(1, sizeof(TypespecPointer));
};

func newTypespecIdentifier(): TypespecIdentifier* {
	return (TypespecIdentifier*)Calloc(1, sizeof(TypespecIdentifier));
};
