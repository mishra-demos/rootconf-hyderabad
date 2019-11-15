BUILD_ID := $(shell git rev-parse --short HEAD 2>/dev/null || echo no-commit-id)
IMAGE := anubhavmishra/jira-on-docker
GOOGLE_PROJECT_ID := hc-da-test

.DEFAULT_GOAL := help
help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-docker-image: ## Build a docker container for the Go service
	docker build -t $(IMAGE):$(BUILD_ID) .
	docker tag $(IMAGE):$(BUILD_ID) $(IMAGE):latest
	docker tag $(IMAGE):$(BUILD_ID) gcr.io/$(GOOGLE_PROJECT_ID)/$(IMAGE):latest

push: ## push docker image to GCR
	docker push gcr.io/$(GOOGLE_PROJECT_ID)/$(IMAGE):latest

run: ## Build and run the project locally
	docker run -p 8080:8080 anubhavmishra/jira-on-docker

describe: ## Describe Google cloud run services and domain mappings
	gcloud beta run services list --platform managed
	gcloud beta run domain-mappings list --platform managed

deploy: ## Deploy image to Google cloud run
	gcloud config set project $(GOOGLE_PROJECT_ID)
	gcloud beta run deploy --image gcr.io/$(GOOGLE_PROJECT_ID)/$(IMAGE):latest --memory 2Gi --timeout 10m --platform managed

configure-docker-registry: ## Configure docker to authenticate with GCR.
	gcloud auth configure-docker