build = build/build.sh
rebuild = build/rebuild.sh
tag = build/tag.sh
publish = build/publish.sh

script_env = \
	VERSIONS="$(VERSIONS)"                            \
	NAMESPACE="$(NAMESPACE)"                          \
	BASE_IMAGE_NAME="$(BASE_IMAGE_NAME)"              \
	VERSION="$(VERSION)"

.PHONY: build
build:
	$(script_env) $(build)

.PHONY: all
all: rebuild test build tags publish

.PHONY: tags
tags:
	$(script_env) $(tag)

.PHONY: publish
publish:
	$(script_env) $(publish)

.PHONY: rebuild
rebuild:
	$(script_env) $(rebuild)

.PHONY: test
test:
	$(script_env) TAG_ON_SUCCESS=$(TAG_ON_SUCCESS) TEST_MODE=true $(build)

.PHONY: clean
clean:
	npm run clean