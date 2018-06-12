var TypeNameVoid: UInt8*;
var TypeNameInt: UInt8*;
var TypeNameBool: UInt8*;
var TypeNameUInt: UInt8*;
var TypeNameInt8: UInt8*;
var TypeNameUInt8: UInt8*;
var TypeNameInt16: UInt8*;
var TypeNameUInt16: UInt8*;
var TypeNameInt32: UInt8*;
var TypeNameUInt32: UInt8*;
var TypeNameInt64: UInt8*;
var TypeNameUInt64: UInt8*;

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
	TypeNameVoid = internLiteral("Void");
	TypeNameBool = internLiteral("Bool");
	TypeNameInt = internLiteral("Int");
	TypeNameUInt = internLiteral("UInt");
	TypeNameInt8 = internLiteral("Int8");
	TypeNameUInt8 = internLiteral("UInt8");
	TypeNameInt16 = internLiteral("Int16");
	TypeNameUInt16 = internLiteral("UInt16");
	TypeNameInt32 = internLiteral("Int32");
	TypeNameUInt32 = internLiteral("UInt32");
	TypeNameInt64 = internLiteral("Int64");
	TypeNameUInt64 = internLiteral("UInt64");
	
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
