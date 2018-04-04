# Include common Makefile code.
BASE_IMAGE_NAME=s2i-nodejs-nginx
NAMESPACE=jshmrtn
VERSIONS = 4.9.1 5.12.0 6.14.1 7.10.1 8.11.1 9.10.1

# Include common Makefile code.
include build/common.mk
