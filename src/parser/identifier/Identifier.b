struct Identifier {
	var pos: SrcPos*;
	var name: String*;
};

func newIdentifier(): Identifier* {
	return (Identifier*)xcalloc(1, sizeof(Identifier));
};
