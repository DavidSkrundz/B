enum TokenKind {
	case Invalid;
	case EOF;
	
	case Comma;
	case Colon;
	case Semicolon;
	
	case OpenCurly;
	case CloseCurly;
	case OpenBracket;
	case CloseBracket;
	case OpenParenthesis;
	case CloseParenthesis;
	
	case Question;
	
	case Plus;
	case Minus;
	case Star;
	case Slash;
	
	case Or;
	case And;
	case Xor;
	case LeftShift;
	case RightShift;
	
	case Not;
	case OrOr;
	case AndAnd;
	case Equal;
	case NotEqual;
	case LessThan;
	case GreaterThan;
	case LessThanEqual;
	case GreaterThanEqual;
	
	case At;
	case Ellipses;
	
	case Assign;
	
	case Dot;
	case Arrow;
	
	case Identifier;
	case BooleanLiteral;
	case IntegerLiteral;
	case CharacterLiteral;
	case StringLiteral;
};

func _printTokenKind(kind: TokenKind, stream: FILE*) {
	if (kind == .EOF) {
		fprintf(stream, (char*)"EOF");
	} else if (kind == .Comma) {
		fprintf(stream, (char*)"COMMA");
	} else if (kind == .Colon) {
		fprintf(stream, (char*)"COLON");
	} else if (kind == .Semicolon) {
		fprintf(stream, (char*)"SEMICOLON");
	} else if (kind == .OpenCurly) {
		fprintf(stream, (char*)"OPENCURLY");
	} else if (kind == .CloseCurly) {
		fprintf(stream, (char*)"CLOSECURLY");
	} else if (kind == .OpenBracket) {
		fprintf(stream, (char*)"OPENBRACKET");
	} else if (kind == .CloseBracket) {
		fprintf(stream, (char*)"CLOSEBRACKET");
	} else if (kind == .OpenParenthesis) {
		fprintf(stream, (char*)"OPENPARENTHESIS");
	} else if (kind == .CloseParenthesis) {
		fprintf(stream, (char*)"CLOSEPARENTHESIS");
	} else if (kind == .At) {
		fprintf(stream, (char*)"AT");
	} else if (kind == .Star) {
		fprintf(stream, (char*)"STAR");
	} else if (kind == .Or) {
		fprintf(stream, (char*)"OR");
	} else if (kind == .And) {
		fprintf(stream, (char*)"AND");
	} else if (kind == .Xor) {
		fprintf(stream, (char*)"XOR");
	} else if (kind == .LeftShift) {
		fprintf(stream, (char*)"LEFTSHIFT");
	} else if (kind == .RightShift) {
		fprintf(stream, (char*)"RIGHTSHIFT");
	} else if (kind == .Question) {
		fprintf(stream, (char*)"QUESTION");
	} else if (kind == .Plus) {
		fprintf(stream, (char*)"PLUS");
	} else if (kind == .Minus) {
		fprintf(stream, (char*)"MINUS");
	} else if (kind == .Slash) {
		fprintf(stream, (char*)"SLASH");
	} else if (kind == .And) {
		fprintf(stream, (char*)"AND");
	} else if (kind == .AndAnd) {
		fprintf(stream, (char*)"AND");
	} else if (kind == .OrOr) {
		fprintf(stream, (char*)"OR");
	} else if (kind == .Not) {
		fprintf(stream, (char*)"NOT");
	} else if (kind == .Assign) {
		fprintf(stream, (char*)"ASSIGN");
	} else if (kind == .Ellipses) {
		fprintf(stream, (char*)"ELLIPSES");
	} else if (kind == .Arrow) {
		fprintf(stream, (char*)"ARROW");
	} else if (kind == .Dot) {
		fprintf(stream, (char*)"DOT");
	} else if (kind == .Equal) {
		fprintf(stream, (char*)"EQUAL");
	} else if (kind == .LessThan) {
		fprintf(stream, (char*)"LESSTHAN");
	} else if (kind == .GreaterThan) {
		fprintf(stream, (char*)"GREATERTHAN");
	} else if (kind == .LessThanEqual) {
		fprintf(stream, (char*)"LESSTHANEQUAL");
	} else if (kind == .GreaterThanEqual) {
		fprintf(stream, (char*)"GREATERTHANEQUAL");
	} else if (kind == .NotEqual) {
		fprintf(stream, (char*)"NOTEQUAL");
	} else if (kind == .Identifier) {
		fprintf(stream, (char*)"IDENTIFIER");
	} else if (kind == .BooleanLiteral) {
		fprintf(stream, (char*)"BOOLEAN");
	} else if (kind == .IntegerLiteral) {
		fprintf(stream, (char*)"INTEGER");
	} else if (kind == .CharacterLiteral) {
		fprintf(stream, (char*)"CHARACTER");
	} else if (kind == .StringLiteral) {
		fprintf(stream, (char*)"STRING");
	} else {
		fprintf(stderr, (char*)"Unknown token kind: %u\n", kind);
		abort();
	};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
};
