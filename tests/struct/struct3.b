struct S {
	var a: UInt;
	
	func setA(newA: UInt) {
		self->a = newA;
	};
	
	func getA(): UInt {
		return self->a;
	};
};

func test() {
	var s: S*;
	s->setA(4);
	s->getA();
};
