TOPDIR := .
include $(TOPDIR)/Makedefs

SRC := $(wildcard src/*.b) $(wildcard src/*/*.b) $(wildcard src/*/*/*.b)

C_SRC := $(wildcard src-c/*.c) $(wildcard src-c/*/*.c) $(wildcard src-c/*/*/*.c)
C_DEP := $(wildcard src-c/*.h) $(wildcard src-c/*/*.h) $(wildcard src-c/*/*/*.h) $(C_SRC)

STATE1_LEX := $(BUILD_DIR)/stage1.lex
STAGE2_LEX := $(BUILD_DIR)/stage2.lex
BC_LEX := $(BUILD_DIR)/bc.lex

STATE1_PARSE := $(BUILD_DIR)/stage1.parse
STAGE2_PARSE := $(BUILD_DIR)/stage2.parse
BC_PARSE := $(BUILD_DIR)/bc.parse

STATE1_C := $(BUILD_DIR)/stage1.c
STAGE2_C := $(BUILD_DIR)/stage2.c
BC_C := $(BUILD_DIR)/bc.c


BOOTSTRAP := $(BUILD_DIR)/bootstrap
STAGE_1 := $(BUILD_DIR)/stage1
STAGE_2 := $(BUILD_DIR)/stage2
BC_NEW := $(BUILD_DIR)/bc

BC := $(BIN_DIR)/bc

all: $(BC_NEW)
	@

install: $(BC) | test
	@

$(BOOTSTRAP): $(C_DEP) | $(BUILD_DIR)
	@$(CC) $(CCFLAGS) -o $@ $(C_SRC)

$(STATE1_LEX): $(BOOTSTRAP) $(SRC)
	@$< -l $(SRC) > $@

$(STATE1_PARSE): $(BOOTSTRAP) $(SRC)
	@$< -p $(SRC) > $@

$(STATE1_C): $(BOOTSTRAP) $(SRC)
	@$< -g $(SRC) > $@

$(STAGE_1): $(STATE1_C) | $(STATE1_LEX) $(STATE1_PARSE) $(STAGE1_C)
	@$(CC) $(CCFLAGS) -o $@ $<

$(STAGE2_LEX): $(STAGE_1) $(SRC)
	@$< -l $(SRC) > $@

$(STAGE2_PARSE): $(STAGE_1) $(SRC)
	@$< -p $(SRC) > $@

$(STAGE2_C): $(STAGE_1) $(SRC)
	@$< -g $(SRC) > $@

$(STAGE_2): $(STAGE2_C) | $(STAGE2_LEX) $(STAGE2_PARSE) $(STAGE2_C)
	@$(CC) $(CCFLAGS) -o $@ $<

$(BC_LEX): $(STAGE_2) $(SRC)
	@$< -l $(SRC) > $@

$(BC_PARSE): $(STAGE_2) $(SRC)
	@$< -p $(SRC) > $@

$(BC_C): $(STAGE_2) $(SRC)
	@$< -g $(SRC) > $@

$(BC_NEW): $(BC_C) | $(BC_LEX) $(BC_PARSE) $(BC_C)
	@$(CC) -o $@ $<

$(BC): $(BC_NEW) | $(BIN_DIR)
	@diff -q $(STAGE2_LEX) $(BC_LEX) >/dev/null || (echo "Stage 3 lexer failed" && exit 1)
	@diff -q $(STAGE2_PARSE) $(BC_PARSE) >/dev/null || (echo "Stage 3 parser failed" && exit 1)
	@diff -q $(STAGE2_C) $(BC_C) >/dev/null || (echo "Stage 3 c codegen failed" && exit 1)
	@cp $< $@

clean:
	@$(RM) -r $(BUILD_DIR)

include $(TOPDIR)/Make.test
