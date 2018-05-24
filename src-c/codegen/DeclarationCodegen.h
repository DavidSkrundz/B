#pragma once

#include "../parser/declaration/Declaration.h"

void codegenDeclarationDefinition(Declaration* declaration);

void CodegenDeclarationDeclarations(void);
void CodegenDeclarationDefinitions(void);
void CodegenDeclarationImplementations(void);
