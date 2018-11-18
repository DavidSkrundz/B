@foreign(c) struct int;
@foreign(c) struct char;
@foreign(c, stdio) func printf(format: char*, ...);
@foreign(c, stdlib) func calloc(count: UInt, size: UInt): Void*;

struct Counter {
	var value: UInt;
	
	func increment() {
		self->value = self->value + 1;
	};
	
	func setValue(newValue: UInt) {
		self->value = newValue;
	};
};

func main(argc: int, argv: char**): int {
	var counter: Counter* = (Counter*)calloc(1, sizeof(Counter));
	counter->setValue(0);
	printf((char*)"%zu\n", counter->value);
	counter->setValue(10);
	printf((char*)"%zu\n", counter->value);
	counter->increment();
	printf((char*)"%zu\n", counter->value);
};
