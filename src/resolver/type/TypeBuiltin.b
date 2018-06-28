var TypeNameVoid: String*;
var TypeNameInt: String*;
var TypeNameBool: String*;
var TypeNameUInt: String*;
var TypeNameInt8: String*;
var TypeNameUInt8: String*;
var TypeNameInt16: String*;
var TypeNameUInt16: String*;
var TypeNameInt32: String*;
var TypeNameUInt32: String*;
var TypeNameInt64: String*;
var TypeNameUInt64: String*;

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
	TypeNameVoid = String_init_literal("Void");
	TypeNameBool = String_init_literal("Bool");
	TypeNameInt = String_init_literal("Int");
	TypeNameUInt = String_init_literal("UInt");
	TypeNameInt8 = String_init_literal("Int8");
	TypeNameUInt8 = String_init_literal("UInt8");
	TypeNameInt16 = String_init_literal("Int16");
	TypeNameUInt16 = String_init_literal("UInt16");
	TypeNameInt32 = String_init_literal("Int32");
	TypeNameUInt32 = String_init_literal("UInt32");
	TypeNameInt64 = String_init_literal("Int64");
	TypeNameUInt64 = String_init_literal("UInt64");
	
	TypeVoid = createTypeIdentifierString(TypeNameVoid);
	TypeBool = createTypeIdentifierString(TypeNameBool);
	TypeInt = createTypeIdentifierString(TypeNameInt);
	TypeUInt = createTypeIdentifierString(TypeNameUInt);
	TypeInt8 = createTypeIdentifierString(TypeNameInt8);
	TypeUInt8 = createTypeIdentifierString(TypeNameUInt8);
	TypeInt16 = createTypeIdentifierString(TypeNameInt16);
	TypeUInt16 = createTypeIdentifierString(TypeNameUInt16);
	TypeInt32 = createTypeIdentifierString(TypeNameInt32);
	TypeUInt32 = createTypeIdentifierString(TypeNameUInt32);
	TypeInt64 = createTypeIdentifierString(TypeNameInt64);
	TypeUInt64 = createTypeIdentifierString(TypeNameUInt64);
	
	TypeAny = resolveTypePointer(TypeVoid);
	TypeCharacter = TypeUInt8;
	TypeString = resolveTypePointer(TypeCharacter);
};
