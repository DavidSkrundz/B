struct Buffer {
	var capacity: UInt;
	var count: UInt;
	var elements: Void*;
};

func _getBuffer(list: Void***): Buffer* {
	if (*list == NULL) {
		var buffer = (Buffer*)xcalloc(1, sizeof(Buffer));
		buffer->capacity = 1;
		*list = &buffer->elements;
		return buffer;
	};
	return (Buffer*)((UInt)*list - offsetof(Buffer, elements));
};

func append(list: Void***, element: Void*) {
	var buffer = _getBuffer(list);
	if (buffer->count == buffer->capacity) {
		buffer->capacity = buffer->capacity * 2;
		buffer = (Buffer*)xrealloc((Void*)buffer, sizeof(Buffer) + buffer->capacity * sizeof(Void*));
		*list = &buffer->elements;
	};
	(*list)[buffer->count] = element;
	buffer->count = buffer->count + 1;
};

func bufferCount(list: Void**): UInt {
	if (list == NULL) { return 0; };
	var buffer = _getBuffer(&list);
	return buffer->count;
};
