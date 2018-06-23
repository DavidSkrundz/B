BUILD_DIR := build
OUTPUT_FILE := $(BUILD_DIR)/gen.c

BC := ../bin/bc -g
B_SRC = $(shell find src -name *.b)

.PHONY: all
all:
	mkdir -p $(BUILD_DIR)
	$(BC) $(B_SRC) > $(OUTPUT_FILE)

.PHONY: clean
clean:
	$(RM) -r $(BUILD_DIR)
