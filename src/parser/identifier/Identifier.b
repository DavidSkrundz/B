struct Identifier {
	var name: UInt8*;
};

func newIdentifier(): Identifier* {
	return (Identifier*)xcalloc(1, sizeof(Identifier));
};
