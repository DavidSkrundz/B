var DeclarationState_Invalid = 0;
var DeclarationState_Unresolved = 0;
var DeclarationState_Resolving = 0;
var DeclarationState_Resolved = 0;

func InitDeclarationStates() {
	var counter = 0;
	
	DeclarationState_Invalid = counter; counter = counter + 1;
	DeclarationState_Unresolved = counter; counter = counter + 1;
	DeclarationState_Resolving = counter; counter = counter + 1;
	DeclarationState_Resolved = counter; counter = counter + 1;
};
