#include "Context.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../utility/Memory.h"

int MAX_CONTEXT_COUNT = 1000;
Context* newContext(void) {
	Context* context = xcalloc(1, sizeof(Context));
	context->names = xcalloc(MAX_CONTEXT_COUNT, sizeof(Identifier*));
	context->types = xcalloc(MAX_CONTEXT_COUNT, sizeof(Type*));
	context->count = 0;
	return context;
}

void addTo(Context* context, Identifier* name, Type* type) {
	if (context->count >= MAX_CONTEXT_COUNT) {
		fprintf(stderr, "Too many functions/variables\n");
		exit(EXIT_FAILURE);
	}
	for (int i = 0; i < context->count; ++i) {
		if (name->length != context->names[i]->length) { continue; }
		if (strncmp(context->names[i]->name, name->name, name->length) != 0) { continue; }
		fprintf(stderr, "Duplicate definition of %.*s\n", name->length, name->name);
		exit(EXIT_FAILURE);
	}
	context->names[context->count] = name;
	context->types[context->count] = type;
	++context->count;
}
