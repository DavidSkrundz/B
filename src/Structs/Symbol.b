struct Symbol {
	var parent: Symbol*;
	var name: String*;
	var type: Type*;
	var pos: SrcPos*;
	var useCount: UInt;
};

func Symbol_init(): Symbol* {
	return (Symbol*)xcalloc(1, sizeof(Symbol));
};
