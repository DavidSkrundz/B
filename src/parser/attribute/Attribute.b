struct Attribute {
	var name: Identifier*;
	var parameters: Identifier**;
};

func newAttribute(): Attribute* {
	return (Attribute*)xcalloc(1, sizeof(Attribute));
};
