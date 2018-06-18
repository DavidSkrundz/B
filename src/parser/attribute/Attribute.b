struct Attribute {
	var pos: SrcPos*;
	var name: Identifier*;
	var parameters: Identifier**;
};

func newAttribute(): Attribute* {
	return (Attribute*)xcalloc(1, sizeof(Attribute));
};
