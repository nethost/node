# Makefile for syncing, signing, and attesting all distroless nodejs nonroot images

# 支持 Node 16~24（注意每个 Node 版本配对不同 debian 版本）
VERSIONS = 24:debian12 22:debian12 20:debian12 18:debian11 16:debian11

SRC_PREFIX = gcr.io/distroless/nodejs
SRC_TAG = latest

DST_REGISTRIES = \
    registry.cn-shanghai.aliyuncs.com/nethost/node \
    docker.io/nethost/node \
    quay.io/nethost/node \
    ghcr.io/nethost/node

COSIGN_KEY = ../cosign.key
VERIFY_KEY = ../cosign.pub

.PHONY: all process verify

all: process

process:
	@for item in $(VERSIONS); do \
	  ver=$${item%%:*}; \
	  deb=$${item##*:}; \
	  src_img="$(SRC_PREFIX)$$ver-$$deb:$(SRC_TAG)"; \
	  for dst in $(DST_REGISTRIES); do \
	    dst_img="$$dst:$$ver"; \
	    echo "==> Copy $$src_img to $$dst_img"; \
	    regctl image copy "$$src_img" "$$dst_img"; \
	    echo "==> Get digest for $$dst_img"; \
	    digest=$$(regctl image digest "$$dst_img"); \
	    full_img="$$dst_img@$$digest"; \
	    echo "==> Cosign sign $$full_img (digest mode)"; \
	    COSIGN_PASSWORD="" cosign sign --yes --key $(COSIGN_KEY) "$$full_img"; \
	    echo "==> Cosign sign $$dst_img (tag mode)"; \
	    COSIGN_PASSWORD="" cosign sign --yes --key $(COSIGN_KEY) "$$dst_img"; \
	    echo "==> Generate SPDX SBOM for $$full_img"; \
	    syft "$$full_img" -o spdx-json > sbom.spdx.json; \
	    echo "==> Cosign SPDX attestation for $$full_img (digest mode)"; \
	    COSIGN_PASSWORD="" cosign attest --yes --predicate sbom.spdx.json --type spdx --key $(COSIGN_KEY) "$$full_img"; \
	    echo "==> Cosign SPDX attestation for $$dst_img (tag mode)"; \
	    COSIGN_PASSWORD="" cosign attest --yes --predicate sbom.spdx.json --type spdx --key $(COSIGN_KEY) "$$dst_img"; \
	    rm -f sbom.spdx.json; \
	    echo "==> Generate CycloneDX SBOM for $$full_img"; \
	    syft "$$full_img" -o cyclonedx-json > sbom.cdx.json; \
	    echo "==> Cosign CycloneDX attestation for $$full_img (digest mode)"; \
	    COSIGN_PASSWORD="" cosign attest --yes --predicate sbom.cdx.json --type cyclonedx --key $(COSIGN_KEY) "$$full_img"; \
	    echo "==> Cosign CycloneDX attestation for $$dst_img (tag mode)"; \
	    COSIGN_PASSWORD="" cosign attest --yes --predicate sbom.cdx.json --type cyclonedx --key $(COSIGN_KEY) "$$dst_img"; \
	    rm -f sbom.cdx.json; \
	    echo "==> Done for $$full_img and $$dst_img"; \
	    echo "-------------------------------------------"; \
	  done \
	done

verify:
	@pubkey="$(VERIFY_KEY)"; \
	if [ -z "$$pubkey" ]; then pubkey="cosign.pub"; fi; \
	for item in $(VERSIONS); do \
	  ver=$${item%%:*}; \
	  for dst in $(DST_REGISTRIES); do \
	    img="$$dst:$$ver"; \
	    echo "==> Verifying signature for $$img"; \
	    cosign verify --key $$pubkey $$img; \
	    echo "==> Verifying SPDX attestation for $$img"; \
	    cosign verify-attestation --type spdx --key $$pubkey $$img; \
	    echo "==> Verifying CycloneDX attestation for $$img"; \
	    cosign verify-attestation --type cyclonedx --key $$pubkey $$img; \
	    echo "-------------------------------------------"; \
	  done \
	done
