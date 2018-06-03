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

func printTokenKind_error(kind: TokenKind) {
	if (kind == .EOF) {
		fprintf(stderr, (char*)"EOF");
	} else if (kind == ._NULL) {
		fprintf(stderr, (char*)"NULL");
	} else if (kind == .Sizeof) {
		fprintf(stderr, (char*)"SIZEOF");
	} else if (kind == .Offsetof) {
		fprintf(stderr, (char*)"OFFSETOF");
	} else if (kind == .Struct) {
		fprintf(stderr, (char*)"STRUCT");
	} else if (kind == .Enum) {
		fprintf(stderr, (char*)"ENUM");
	} else if (kind == .Var) {
		fprintf(stderr, (char*)"VAR");
	} else if (kind == .Func) {
		fprintf(stderr, (char*)"FUNC");
	} else if (kind == .If) {
		fprintf(stderr, (char*)"IF");
	} else if (kind == .Else) {
		fprintf(stderr, (char*)"ELSE");
	} else if (kind == .While) {
		fprintf(stderr, (char*)"WHILE");
	} else if (kind == .Return) {
		fprintf(stderr, (char*)"RETURN");
	} else if (kind == .Case) {
		fprintf(stderr, (char*)"CASE");
	} else if (kind == .Comma) {
		fprintf(stderr, (char*)"COMMA (,)");
	} else if (kind == .Colon) {
		fprintf(stderr, (char*)"COLON (:)");
	} else if (kind == .Semicolon) {
		fprintf(stderr, (char*)"SEMICOLON (;)");
	} else if (kind == .OpenCurly) {
		fprintf(stderr, (char*)"OPENCURLY ({)");
	} else if (kind == .CloseCurly) {
		fprintf(stderr, (char*)"CLOSECURLY (})");
	} else if (kind == .OpenBracket) {
		fprintf(stderr, (char*)"OPENBRACKET ([)");
	} else if (kind == .CloseBracket) {
		fprintf(stderr, (char*)"CLOSEBRACKET (])");
	} else if (kind == .OpenParenthesis) {
		fprintf(stderr, (char*)"OPENPARENTHESIS (()");
	} else if (kind == .CloseParenthesis) {
		fprintf(stderr, (char*)"CLOSEPARENTHESIS ())");
	} else if (kind == .At) {
		fprintf(stderr, (char*)"AT (@)");
	} else if (kind == .Star) {
		fprintf(stderr, (char*)"STAR (*)");
	} else if (kind == .And) {
		fprintf(stderr, (char*)"AND (&)");
	} else if (kind == .Plus) {
		fprintf(stderr, (char*)"PLUS (+)");
	} else if (kind == .Minus) {
		fprintf(stderr, (char*)"MINUS (-)");
	} else if (kind == .Slash) {
		fprintf(stderr, (char*)"SLASH (/)");
	} else if (kind == .And) {
		fprintf(stderr, (char*)"AND (&)");
	} else if (kind == .AndAnd) {
		fprintf(stderr, (char*)"AND (&&)");
	} else if (kind == .OrOr) {
		fprintf(stderr, (char*)"OR (||)");
	} else if (kind == .Not) {
		fprintf(stderr, (char*)"NOT (!)");
	} else if (kind == .Assign) {
		fprintf(stderr, (char*)"ASSIGN (=)");
	} else if (kind == .Ellipses) {
		fprintf(stderr, (char*)"ELLIPSES (...)");
	} else if (kind == .Arrow) {
		fprintf(stderr, (char*)"ARROW (->)");
	} else if (kind == .Dot) {
		fprintf(stderr, (char*)"DOT (.)");
	} else if (kind == .Equal) {
		fprintf(stderr, (char*)"EQUAL (==)");
	} else if (kind == .LessThan) {
		fprintf(stderr, (char*)"LESSTHAN (<)");
	} else if (kind == .LessThanEqual) {
		fprintf(stderr, (char*)"LESSTHANEQUAL (<=)");
	} else if (kind == .NotEqual) {
		fprintf(stderr, (char*)"NOTEQUAL (!=)");
	} else if (kind == .Identifier) {
		fprintf(stderr, (char*)"IDENTIFIER (_)");
	} else if (kind == .BooleanLiteral) {
		fprintf(stderr, (char*)"BOOLEAN (_)");
	} else if (kind == .IntegerLiteral) {
		fprintf(stderr, (char*)"INTEGER (_)");
	} else if (kind == .CharacterLiteral) {
		fprintf(stderr, (char*)"CHARACTER (_)");
	} else if (kind == .StringLiteral) {
		fprintf(stderr, (char*)"STRING (_)");
	} else {
		fprintf(stderr, (char*)"Unknown token kind: %u%c", kind, 10);
		abort();
	};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
};
