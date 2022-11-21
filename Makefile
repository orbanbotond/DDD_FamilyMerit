CONTEXTS = $(shell find merits -type d -maxdepth 1 -mindepth 1 -exec basename {} \;)

$(addprefix test-, $(CONTEXTS)):
	@make -C merits/$(subst test-,,$@) test

$(addprefix install-, $(CONTEXTS)):
	@make -C merits/$(subst test-,,$@) test

install:
	$(addprefix install-, $(CONTEXTS))

test: $(addprefix test-, $(CONTEXTS))

help:
	@echo "help"
# 	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)

# | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.DEFAULT_GOAL := help
