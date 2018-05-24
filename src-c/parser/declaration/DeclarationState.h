#pragma once

extern int DeclarationState_Invalid;
extern int DeclarationState_Unresolved;
extern int DeclarationState_Resolving;
extern int DeclarationState_Resolved;

void InitDeclarationStates(void);
