struct SrcPos {
	var file: UInt8*;
	var start: UInt8*;
	var line: UInt;
	var column: UInt;
};

func newSrcPos(file: UInt8*, start: UInt8*, line: UInt, column: UInt): SrcPos* {
	var pos = (SrcPos*)xcalloc(1, sizeof(SrcPos));
	pos->file = file;
	pos->start = start;
	pos->line = line;
	pos->column = column;
	return pos;
};
