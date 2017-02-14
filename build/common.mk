build = build/build.sh

script_env = \
	VERSIONS="$(VERSIONS)"                            \
	NAMESPACE="$(NAMESPACE)"                          \
	BASE_IMAGE_NAME="$(BASE_IMAGE_NAME)"              \
	VERSION="$(VERSION)"

.PHONY: build
build:
	$(script_env) $(build)

.PHONY: all
all:
	make rebuild && make test && make build && make tags && make publish

.PHONY: tags
tags:
	$(script_env) npm run tag

.PHONY: publish
publish:
	$(script_env) npm run pub

.PHONY: rebuild
rebuild:
	$(script_env) npm run rebuild

.PHONY: test
test:
	$(script_env) TAG_ON_SUCCESS=$(TAG_ON_SUCCESS) TEST_MODE=true $(build)

.PHONY: clean
clean:
	npm run clean