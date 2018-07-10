func Resolve() {
	pushContext();
	InitBuiltinTypes();
	
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		resolveDeclaration(_declarations[i], true);
		i = i + 1;
	};
};
