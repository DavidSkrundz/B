var genDepth = 0;

func codegenDepth() {
	var i = 0;
	while (i < genDepth) {
		printf((char*)"%c", '\t');
		i = i + 1;
	};
};
