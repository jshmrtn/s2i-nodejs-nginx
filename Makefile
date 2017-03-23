# Include common Makefile code.
BASE_IMAGE_NAME=s2i-nodejs-nginx
NAMESPACE=jshmrtn
VERSIONS = 4.8.1 5.12.0 6.10.1 7.7.4

# Include common Makefile code.
include build/common.mk
