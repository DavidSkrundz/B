struct Buffer {
	var capacity: UInt;
	var count: UInt;
	var elements: Void*;
};

func _Buffer_get(list: Void***): Buffer* {
	if (*list == NULL) {
		var buffer = (Buffer*)xcalloc(1, sizeof(Buffer));
		buffer->capacity = 1;
		*list = &buffer->elements;
		return buffer;
	};
	return (Buffer*)((UInt)*list - offsetof(Buffer, elements));
};

func Buffer_append(list: Void***, element: Void*) {
	var buffer = _Buffer_get(list);
	if (buffer->count == buffer->capacity) {
		buffer->capacity = buffer->capacity * 2;
		buffer = (Buffer*)xrealloc((Void*)buffer, sizeof(Buffer) + buffer->capacity * sizeof(Void*));
		*list = &buffer->elements;
	};
	(*list)[buffer->count] = element;
	buffer->count = buffer->count + 1;
};

func Buffer_getCount(list: Void**): UInt {
	if (list == NULL) { return 0; };
	var buffer = _Buffer_get(&list);
	return buffer->count;
};

func Buffer_setCount(list: Void**, count: UInt) {
	var buffer = _Buffer_get(&list);
	buffer->count = count;
};
