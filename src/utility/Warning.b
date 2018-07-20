func ResolverWarning(pos: SrcPos*, message1: UInt8*, message2: UInt8*, message3: UInt8*, pos2: SrcPos*) {
	fprintf(stderr, (char*)"%s:%zu:%zu: ", pos->file, pos->line, pos->column);
	fprintf(stderr, (char*)"warning: %s%s%s%s:%zu:%zu\n", message1, message2, message3, pos2->file, pos2->line, pos2->column);
	_printUpToNewline(pos->start);
	_printErrorLocation(pos->start, pos->column);
};
