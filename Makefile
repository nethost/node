# Makefile for syncing distroless nodejs images to multiple registries using regctl

NODE_VERSIONS = 24 22 20
SRC_PREFIX = gcr.io/distroless/nodejs
SRC_SUFFIX = -debian12
DST_REGISTRIES = \
    registry.cn-shanghai.aliyuncs.com/nethost/node \
    docker.io/nethost/node \
    quay.io/nethost/node \
    ghcr.io/nethost/node

.PHONY: all sync

all: sync

sync:
	@for ver in $(NODE_VERSIONS); do \
	    for dst in $(DST_REGISTRIES); do \
	        src=$(SRC_PREFIX)$$ver$(SRC_SUFFIX); \
	        echo "==> Syncing version $$ver: $$src to $$dst:$$ver"; \
	        regctl image copy $$src $$dst:$$ver; \
	    done \
	done
