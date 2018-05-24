#pragma once

typedef struct {
	int kind;
	char* value;
	int length;
} Token;

Token* newToken(void);
