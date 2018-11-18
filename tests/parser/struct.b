struct Value {
	var value: UInt;
	
	func getSet(newValue: UInt): UInt {
		var tmp = self->value;
		self->value = newValue;
		return tmp;
	};
};
