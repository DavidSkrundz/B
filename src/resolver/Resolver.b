var _context: Context*;

func Resolve() {
	InitTypeKinds();
	
	_context = newContext();
	
	InitBuiltinTypes();
	
	var i = 0;
	while (i < _declarationCount) {
		resolveDeclarationType(_declarations[i]);
		i = i + 1;
	};
	
	i = 0;
	while (i < _declarationCount) {
		resolveDeclarationDefinition(_declarations[i]);
		i = i + 1;
	};
	
	i = 0;
	while (i < _declarationCount) {
		resolveDeclarationImplementation(_declarations[i]);
		i = i + 1;
	};
};
