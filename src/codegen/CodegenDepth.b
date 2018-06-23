var genDepth = 0;

func codegenDepth() {
	var i = 0;
	while (i < genDepth) {
		printf((char*)"\t");
		i = i + 1;
	};
};

func codegenLine(pos: SrcPos*) {
	printf((char*)"#line %zu \"%s\"\n", pos->line, pos->file);
	codegenDepth();
};
