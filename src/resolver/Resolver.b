var _types: Type**;
var _typeCount = (UInt)0;
var _context: Context*;

var MAX_TYPE_COUNT = (UInt)1000;
func Resolve() {
	InitTypeKinds();
	
	_types = (Type**)xcalloc(MAX_TYPE_COUNT, sizeof(Type*));
	_typeCount = (UInt)0;
	_context = newContext();
	
	InitBuiltinTypes();
	
	var i = (UInt)0;
	while (i < _declarationCount) {
		resolveDeclarationType(_declarations[i]);
		i = i + (UInt)1;
	};
	
	i = (UInt)0;
	while (i < _declarationCount) {
		resolveDeclarationDefinition(_declarations[i]);
		i = i + (UInt)1;
	};
	
	i = (UInt)0;
	while (i < _declarationCount) {
		resolveDeclarationImplementation(_declarations[i]);
		i = i + (UInt)1;
	};
};
