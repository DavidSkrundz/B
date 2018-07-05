var TypeVoid: Type*;
var TypeBool: Type*;
var TypeInt: Type*;
var TypeUInt: Type*;
var TypeInt8: Type*;
var TypeUInt8: Type*;
var TypeInt16: Type*;
var TypeUInt16: Type*;
var TypeInt32: Type*;
var TypeUInt32: Type*;
var TypeInt64: Type*;
var TypeUInt64: Type*;

var TypeAny: Type*;
var TypeCharacter: Type*;
var TypeString: Type*;

func InitBuiltinTypes() {
	TypeVoid = registerBuiltinType("Void");
	TypeBool = registerBuiltinType("Bool");
	TypeInt = registerBuiltinType("Int");
	TypeUInt = registerBuiltinType("UInt");
	TypeInt8 = registerBuiltinType("Int8");
	TypeUInt8 = registerBuiltinType("UInt8");
	TypeInt16 = registerBuiltinType("Int16");
	TypeUInt16 = registerBuiltinType("UInt16");
	TypeInt32 = registerBuiltinType("Int32");
	TypeUInt32 = registerBuiltinType("UInt32");
	TypeInt64 = registerBuiltinType("Int64");
	TypeUInt64 = registerBuiltinType("UInt64");
	
	TypeAny = resolveTypePointer(TypeVoid);
	TypeCharacter = TypeUInt8;
	TypeString = resolveTypePointer(TypeCharacter);
};

func registerBuiltinType(name: UInt8*): Type* {
	var stringName = String_init_literal(name);
	var type = newType();
	type->kind = .Identifier;
	type->type = (Void*)TypeIdentifier_init(stringName);
	registerType(type);
	return type;
};
