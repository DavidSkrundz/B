#pragma once

#include "../parser/declaration/Declaration.h"

void resolveDeclarationType(Declaration* declaration);
void resolveDeclarationDefinition(Declaration* declaration);
void resolveDeclarationImplementation(Declaration* declaration);
