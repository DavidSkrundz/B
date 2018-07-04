struct Symbol {
	var parent: Symbol*;
	var name: String*;
	var type: Type*;
	var pos: SrcPos*;
	var useCount: UInt;
};
