# Include common Makefile code.
BASE_IMAGE_NAME=s2i-nodejs-nginx
NAMESPACE=jshmrtn
VERSIONS = 4.7.3 5.12.0 6.9.5 7.5.0

# Include common Makefile code.
include build/common.mk
