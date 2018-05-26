struct Attribute {
	var name: Identifier*;
};

func newAttribute(): Attribute* {
	return (Attribute*)xcalloc(1, sizeof(Attribute));
};
