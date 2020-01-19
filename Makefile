DOCKER_IMAGE_REPO ?= ""
GIT_HASH = $(shell git rev-parse HEAD | cut -c 1-7)

all: build-image push-image deploy-infra

build-image:
	cd app && docker build -t $(DOCKER_IMAGE_REPO):$(GIT_HASH) .
push-image:
	docker push $(DOCKER_IMAGE_REPO):$(GIT_HASH)
plan-infra:
	cd infra && terraform plan \
	-var-file="vars.tfvars" \
	-var="app_docker_image=$(DOCKER_IMAGE_REPO):$(GIT_HASH)"
deploy-infra:
	cd infra && \
	terraform apply \
	-var-file="vars.tfvars" \
	-var="app_docker_image=$(DOCKER_IMAGE_REPO):$(GIT_HASH)"
