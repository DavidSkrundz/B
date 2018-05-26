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
	TypeVoid = createTypeIdentifierString("Void");
	TypeBool = createTypeIdentifierString("Bool");
	TypeInt = createTypeIdentifierString("Int");
	TypeUInt = createTypeIdentifierString("UInt");
	TypeInt8 = createTypeIdentifierString("Int8");
	TypeUInt8 = createTypeIdentifierString("UInt8");
	TypeInt16 = createTypeIdentifierString("Int16");
	TypeUInt16 = createTypeIdentifierString("UInt16");
	TypeInt32 = createTypeIdentifierString("Int32");
	TypeUInt32 = createTypeIdentifierString("UInt32");
	TypeInt64 = createTypeIdentifierString("Int64");
	TypeUInt64 = createTypeIdentifierString("UInt64");
	
	TypeAny = createTypePointer(TypeVoid);
	TypeCharacter = TypeUInt8;
	TypeString = createTypePointer(TypeCharacter);
};
