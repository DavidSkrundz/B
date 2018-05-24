var genDepth = (UInt)0;

func codegenDepth() {
	var i = (UInt)0;
	while (i < genDepth) {
		printf((char*)"%c", 9);
		i = i + (UInt)1;
	};
};
