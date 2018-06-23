var _context: Context*;

func Resolve() {
	_context = newContext();
	
	InitBuiltinTypes();
	
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		resolveDeclarationType(_declarations[i]);
		i = i + 1;
	};
	
	i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		resolveDeclarationDefinition(_declarations[i]);
		i = i + 1;
	};
	
	i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		resolveDeclarationImplementation(_declarations[i]);
		i = i + 1;
	};
};
