struct Symbol {
	var parent: Symbol*;
	var children: Context*;
	
	var name: String*;
	var type: Type*;
	
	var isType: Bool;
	
	var pos: SrcPos*;
	var useCount: UInt;
	
	func use(self: Symbol*) {
		self->useCount = self->useCount + 1;
	};

	func isUnused(self: Symbol*): Bool {
		return self->useCount == 0;
	};
};

func Symbol_init(): Symbol* {
	return (Symbol*)xcalloc(1, sizeof(Symbol));
};

