struct S {
	var a: UInt;
	
	func setA(self: S*, newA: UInt) {
		self->a = newA;
	};
	
	func getA(self: S*): UInt {
		return self->a;
	};
};

func test() {
	var s: S*;
	s->setA(4);
	s->getA();
};
