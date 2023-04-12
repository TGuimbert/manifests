.DEFAULT_GOAL: all

SOURCES_DIR   := $(PWD)/sources
RESOURCES_DIR := $(PWD)/resources
DARK          := dark

# $(RESOURCES_DIR)/$(DARK): $(SOURCES_DIR)/$(DARK)
# 	kustomize build $^ > $@

$(RESOURCES_DIR)/%.yaml: $(SOURCES_DIR)/%/*
	kustomize build $(dir $^) > $@

.PHONY: dark
dark: $(RESOURCES_DIR)/dark.yaml

all: dark