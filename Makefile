# Include common Makefile code.
BASE_IMAGE_NAME=s2i-nodejs-nginx
NAMESPACE=jshmrtn
VERSIONS = 4.8.0 5.12.0 6.10.0 7.7.2

# Include common Makefile code.
include build/common.mk
