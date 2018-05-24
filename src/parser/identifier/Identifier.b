struct Identifier {
	var name: UInt8*;
	var length: UInt;
};

func newIdentifier(): Identifier* {
	return (Identifier*)xcalloc((UInt)1, sizeof(Identifier));
};
