var _OldContext: OldContext*;

func Resolve() {
	_OldContext = newOldContext();
	
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
