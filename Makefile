include Makefile.version
# info
.DEFAULT_GOAL := container
.NOTPARALLEL:

REPO_NAME=$(shell basename `git rev-parse --show-toplevel`)

.PHONY: all
all: container run-app

.PHONY: clean
clean: stop-app clean-docker

.PHONY: clean-docker
clean-docker:
	@echo "🧹 Cleaning 🐳 cruft"
	@docker system prune -f --volumes

.PHONY: container
container:
	@echo "✅ Building a new 🐳 image for '$(REPO_NAME)'"
	@docker build -t $(REPO_NAME) .

.PHONY: deploy-qa
deploy-qa:
	@echo "🚢 deploying $(REPO_NAME) to the Bosun QA Cluster (eu-west-1)"
	@kubectx qa-eu-a
	$(call deploy,qa)

.PHONY: deploy-prod
deploy-prod:
	@echo "🚢 deploying $(REPO_NAME) to the Bosun PROD Cluster (us-east-1)"
	@kubectx prod-us-a
	$(call deploy,prod)

.PHONY: docker-prune
docker-prune: clean-docker

.PHONY: docker-run
docker-run: run-app

.PHONY: docker-stop
docker-stop: stop-app

.PHONY: release-major
release-major:
	$(eval TAG=$(shell make tag-major))
	$(call tag,$(TAG))

.PHONY: release-minor
release-minor:
	$(eval TAG=$(shell make tag-minor))
	$(call tag,$(TAG))

.PHONY: release-micro
release-micro:
	$(eval TAG=$(shell make tag-micro))
	$(call tag,$(TAG))

.PHONY: run-app
run-app:
	@docker run -d -p 8080:8080 -l name=$(REPO_NAME) $(REPO_NAME):latest
	@echo "✅ 🐳 container for '$(REPO_NAME)' started"
	@echo "Open your browser and navigate to 'http://localhost:8080'"

.PHONY: start-app
start-app: run-app

.PHONY: stop-app
stop-app:
	@$(eval CONTAINER=$(shell docker ps -q -f "label=name=$(REPO_NAME)"))
	@echo "🛑 Stopping the currently running 🐳 container '$(REPO_NAME)'"
	-@docker stop $(CONTAINER)

.PHONY: upgrade-prod
upgrade-prod: deploy-prod

.PHONY: upgrade-qa
upgrade-qa: deploy-qa

.PHONY: update-prod
update-prod: deploy-prod

.PHONY: update-qa
update-qa: deploy-qa

define deploy
	@$(eval NS=$(shell grep 'team: ' deploy/helm/demo/values.yaml| cut -d'"' -f2))
	helm upgrade --install -n $(NS) demo ./deploy/helm/demo/ -f ./deploy/helm/demo/values.yaml -f ./deploy/helm/demo/values-$(1).yaml
endef

define tag
	@echo "🚢  creating 'git' tag for release '$(1)'"
	git tag $(1) -m '$(TAG_MESSAGE)'
	git push --tags
	@echo "🚢  'git' tag '$(1)' created and pushed"
endef
