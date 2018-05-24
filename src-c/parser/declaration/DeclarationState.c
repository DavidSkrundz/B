#include "DeclarationState.h"

int DeclarationState_Invalid;
int DeclarationState_Unresolved;
int DeclarationState_Resolving;
int DeclarationState_Resolved;

void InitDeclarationStates(void) {
	int counter = 0;
	
	DeclarationState_Invalid = counter++;
	DeclarationState_Unresolved = counter++;
	DeclarationState_Resolving = counter++;
	DeclarationState_Resolved = counter++;
}
