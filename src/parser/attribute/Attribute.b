struct Attribute {
	var name: Identifier*;
};

func newAttribute(): Attribute* {
	return (Attribute*)xcalloc((UInt)1, sizeof(Attribute));
};
