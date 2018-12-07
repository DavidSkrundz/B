struct Attribute {
	var pos: SrcPos*;
	var name: Token*;
	var parameters: Token**;
};

func newAttribute(): Attribute* {
	return (Attribute*)Calloc(1, sizeof(Attribute));
};
