SOURCE_DIR = sources
HEADER_DIR = headers
OBJECT_DIR = objects
DEPENDENCY_DIR = dependencies

SOURCES = $(wildcard $(SOURCE_DIR)/*.c)
HEADERS = $(SOURCES:$(SOURCE_DIR)/%.c=$(HEADER_DIR)/%.h)
OBJECTS = $(SOURCES:$(SOURCE_DIR)/%.c=$(OBJECT_DIR)/%.o)
DEPENDENCIES = $(SOURCES:$(SOURCE_DIR)/%.c=$(DEPENDENCY_DIR)/%.d)
DIRS = $(OBJECT_DIR) $(DEPENDENCY_DIR)
CC_FLAGS = -Wall -g -I$(HEADER_DIR)
DEPENDENCY_FLAGS = -MMD
CC = gcc
##Name your program here
PROJECT = untitled

all: $(PROJECT)

rebuild: clean all

$(PROJECT): $(OBJECTS)
	$(CC) -o $@ $^ -lm


$(OBJECTS): $(OBJECT_DIR)/%.o: $(SOURCE_DIR)/%.c | $(OBJECT_DIR) $(DEPENDENCY_DIR)
	$(CC) $(CC_FLAGS) $(DEPENDENCY_FLAGS) -MF $(@:$(@D)%.o=$(DEPENDENCY_DIR)%.d) -c -o $@ $<

-include $(DEPENDENCIES)

$(DIRS):
	mkdir -p $@

clean:
	rm -fr $(DIRS) $(PROJECT) 
	
ANALYZER = $(shell /usr/local/bin/brew --prefix llvm)/bin/scan-build
analysis:
	$(ANALYZER) -v -v -v -o $(PROJECT)-analysis make $(PROJECT)

.PHONY: clean analysis
