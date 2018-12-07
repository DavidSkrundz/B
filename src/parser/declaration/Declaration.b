struct Declaration {
	var pos: SrcPos*;
	var kind: DeclarationKind;
	var state: DeclarationState;
	var attribute: Attribute*;
	var name: Token*;
	var declaration: Void*;
	var symbol: Symbol*;
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
	var functions: Declaration**;
};

struct DeclarationEnumCase {
	var name: Token*;
};

struct DeclarationEnum {
	var cases: DeclarationEnumCase**;
};

func newDeclaration(): Declaration* {
	return (Declaration*)Calloc(1, sizeof(Declaration));
};

func newDeclarationVar(): DeclarationVar* {
	return (DeclarationVar*)Calloc(1, sizeof(DeclarationVar));
};

func newDeclarationFuncArg(): DeclarationFuncArg* {
	return (DeclarationFuncArg*)Calloc(1, sizeof(DeclarationFuncArg));
};

func newDeclarationFuncArgs(): DeclarationFuncArgs* {
	return (DeclarationFuncArgs*)Calloc(1, sizeof(DeclarationFuncArgs));
};

func newDeclarationFunc(): DeclarationFunc* {
	return (DeclarationFunc*)Calloc(1, sizeof(DeclarationFunc));
};

func newDeclarationStruct(): DeclarationStruct* {
	return (DeclarationStruct*)Calloc(1, sizeof(DeclarationStruct));
};

func newDeclarationEnumCase(): DeclarationEnumCase* {
	return (DeclarationEnumCase*)Calloc(1, sizeof(DeclarationEnumCase));
};

func newDeclarationEnum(): DeclarationEnum* {
	return (DeclarationEnum*)Calloc(1, sizeof(DeclarationEnum));
};
