#include "Resolver.h"

#include <stdlib.h>

#include "../parser/Parser.h"
#include "type/Type.h"
#include "type/TypeKind.h"
#include "type/TypeBuiltin.h"
#include "DeclarationResolve.h"
#include "../utility/Memory.h"

Type** types = NULL;
int typeCount = 0;
Context* context = NULL;

int MAX_TYPE_COUNT = 1000;
void Resolve(void) {
	InitTypeKinds();
	
	types = xcalloc(MAX_TYPE_COUNT, sizeof(Type*));
	typeCount = 0;
	context = newContext();
	
	InitBuiltinTypes();
	
	for (int i = 0; i < declarationCount; ++i) {
		resolveDeclarationType(declarations[i]);
	}
	
	for (int i = 0; i < declarationCount; ++i) {
		resolveDeclarationDefinition(declarations[i]);
	}
	
	for (int i = 0; i < declarationCount; ++i) {
		resolveDeclarationImplementation(declarations[i]);
	}
}
