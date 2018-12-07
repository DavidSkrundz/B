func ErrorEater() {
	if (false) { ErrorEater(); };
	Free(NULL);
	Valloc(0);
	PrintUInt(0);
	(Void)SEEK_CUR;
};
