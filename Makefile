.DEFAULT_GOAL: test

SOURCES_DIR   := $(PWD)/sources
POLICIES_DIR  := $(PWD)/policies

########
# TEST #
########

.PHONY: test-%
directory = $(subst test-,,$@)
test-%:
	@echo "Testing kyverno policies on $(directory)"
	@kustomize build sources/$(directory) | kyverno apply $(POLICIES_DIR) -r /dev/stdin

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
