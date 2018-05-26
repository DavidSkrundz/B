struct Context {
	var names: Identifier**;
	var types: Type**;
	var count: UInt;
};

var MAX_CONTEXT_COUNT = 1000;
func newContext(): Context* {
	var context = (Context*)xcalloc(1, sizeof(Context));
	context->names = (Identifier**)xcalloc(MAX_CONTEXT_COUNT, sizeof(Identifier*));
	context->types = (Type**)xcalloc(MAX_CONTEXT_COUNT, sizeof(Type*));
	context->count = 0;
	return context;
};

func addTo(context: Context*, name: Identifier*, type: Type*) {
	if (context->count == MAX_CONTEXT_COUNT) {
		fprintf(stderr, (char*)"Too many functions/variables%c", 10);
		exit(EXIT_FAILURE);
	};
	var i = 0;
	while (i < context->count) {
		if (name->length == context->names[i]->length) {
			if (strncmp((char*)context->names[i]->name, (char*)name->name, name->length) == (int)0) {
				fprintf(stderr, (char*)"Duplicate definition of %.*s%c", (int)name->length, name->name, 10);
				exit(EXIT_FAILURE);
			};
		};
		i = i + 1;
	};
	context->names[context->count] = name;
	context->types[context->count] = type;
	context->count = context->count + 1;
};
