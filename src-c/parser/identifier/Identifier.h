#pragma once

typedef struct {
	char* name;
	int length;
} Identifier;

Identifier* newIdentifier(void);
