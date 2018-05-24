struct Declaration {
	var kind: UInt;
	var state: UInt;
	var attribute: Attribute*;
	var name: Identifier*;
	var declaration: Void*;
	var resolvedType: Type*;
};

struct DeclarationVar {
	var type: Typespec*;
	var value: Expression*;
};

struct DeclarationFuncArg {
	var name: Identifier*;
	var type: Typespec*;
	var resolvedType: Type*;
};

struct DeclarationFuncArgs {
	var args: DeclarationFuncArg**;
	var count: UInt;
	var isVariadic: Bool;
};

struct DeclarationFunc {
	var args: DeclarationFuncArgs*;
	var returnType: Typespec*;
	var block: StatementBlock*;
};

struct DeclarationStructFields {
	var fields: Declaration**;
	var count: UInt;
};

struct DeclarationStruct {
	var fields: DeclarationStructFields*;
};

func newDeclaration(): Declaration* {
	return (Declaration*)xcalloc((UInt)1, sizeof(Declaration));
};

func newDeclarationVar(): DeclarationVar* {
	return (DeclarationVar*)xcalloc((UInt)1, sizeof(DeclarationVar));
};

func newDeclarationFuncArg(): DeclarationFuncArg* {
	return (DeclarationFuncArg*)xcalloc((UInt)1, sizeof(DeclarationFuncArg));
};

func newDeclarationFuncArgs(): DeclarationFuncArgs* {
	return (DeclarationFuncArgs*)xcalloc((UInt)1, sizeof(DeclarationFuncArgs));
};

func newDeclarationFunc(): DeclarationFunc* {
	return (DeclarationFunc*)xcalloc((UInt)1, sizeof(DeclarationFunc));
};

func newDeclarationStructFields(): DeclarationStructFields* {
	return (DeclarationStructFields*)xcalloc((UInt)1, sizeof(DeclarationStructFields));
};

func newDeclarationStruct(): DeclarationStruct* {
	return (DeclarationStruct*)xcalloc((UInt)1, sizeof(DeclarationStruct));
};
