enum TokenKind {
	case Invalid;
	case EOF;
	case _NULL;

	case Sizeof;
	case Offsetof;

	case Var;
	case Func;
	case Struct;
	case Enum;

	case If;
	case Else;
	case While;
	case Return;
	case Case;

	case Comma;
	case Colon;
	case Semicolon;
	case OpenCurly;
	case CloseCurly;
	case OpenBracket;
	case CloseBracket;
	case OpenParenthesis;
	case CloseParenthesis;

	case At;
	case Star;
	case And;
	case Assign;
	case Ellipses;
	case Arrow;
	case Dot;

	case AndAnd;
	case OrOr;

	case Plus;
	case Minus;
	case Slash;
	case Not;
	case Equal;
	case LessThan;
	case LessThanEqual;
	case NotEqual;

	case Identifier;
	case BooleanLiteral;
	case IntegerLiteral;
	case CharacterLiteral;
	case StringLiteral;
};
