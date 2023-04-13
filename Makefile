.DEFAULT_GOAL: all

SOURCES_DIR   := $(PWD)/sources
RESOURCES_DIR := $(PWD)/resources
POLICIES_DIR  := $(PWD)/policies

#########
# BUILD #
#########

$(RESOURCES_DIR)/%/: $(SOURCES_DIR)/%/*
	mkdir -p $@
	kustomize build $(dir $^) --output $@

.PHONY: dark
dark: $(RESOURCES_DIR)/dark/

.PHONY: all
all: dark

########
# TEST #
########

.PHONY: test-%
test-%:
	kyverno apply $(POLICIES_DIR) -r $(RESOURCES_DIR)/$(subst test-,,$@)

.PHONY: test-all
test-all: test-dark

.PHONY: test
test: test-all

############
# POLICIES #
############

CATEGORIES     := $(wildcard $(POLICIES_DIR)/*/)
best-practices := require-labels
POLICIES := $(wildcard $(POLICIES_DIR)/*/*.yaml)

.PHONY: $(POLICIES)
$(POLICIES):
	echo $(POLICIES)
	curl -o $@ https://raw.githubusercontent.com/kyverno/policies/main/$(subst $(POLICIES_DIR)/,,$(dir $@))$(basename $(notdir $@))/$(notdir $@)

.PHONY: download-policies
download-policies: $(POLICIES)
