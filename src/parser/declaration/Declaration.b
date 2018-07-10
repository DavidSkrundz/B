struct Declaration {
	var pos: SrcPos*;
	var kind: DeclarationKind;
	var state: DeclarationState;
	var attribute: Attribute*;
	var name: Token*;
	var declaration: Void*;
	var resolvedType: Type*;
};

struct DeclarationVar {
	var type: Typespec*;
	var value: Expression*;
};

struct DeclarationFuncArg {
	var pos: SrcPos*;
	var name: Token*;
	var type: Typespec*;
	var resolvedType: Type*;
};

struct DeclarationFuncArgs {
	var args: DeclarationFuncArg**;
	var isVariadic: Bool;
};

struct DeclarationFunc {
	var args: DeclarationFuncArgs*;
	var returnType: Typespec*;
	var block: StatementBlock*;
};

struct DeclarationStruct {
	var fields: Declaration**;
};

struct DeclarationEnumCase {
	var name: Token*;
};

struct DeclarationEnum {
	var cases: DeclarationEnumCase**;
};

func newDeclaration(): Declaration* {
	return (Declaration*)xcalloc(1, sizeof(Declaration));
};

func newDeclarationVar(): DeclarationVar* {
	return (DeclarationVar*)xcalloc(1, sizeof(DeclarationVar));
};

func newDeclarationFuncArg(): DeclarationFuncArg* {
	return (DeclarationFuncArg*)xcalloc(1, sizeof(DeclarationFuncArg));
};

func newDeclarationFuncArgs(): DeclarationFuncArgs* {
	return (DeclarationFuncArgs*)xcalloc(1, sizeof(DeclarationFuncArgs));
};

func newDeclarationFunc(): DeclarationFunc* {
	return (DeclarationFunc*)xcalloc(1, sizeof(DeclarationFunc));
};

func newDeclarationStruct(): DeclarationStruct* {
	return (DeclarationStruct*)xcalloc(1, sizeof(DeclarationStruct));
};

func newDeclarationEnumCase(): DeclarationEnumCase* {
	return (DeclarationEnumCase*)xcalloc(1, sizeof(DeclarationEnumCase));
};

func newDeclarationEnum(): DeclarationEnum* {
	return (DeclarationEnum*)xcalloc(1, sizeof(DeclarationEnum));
};
