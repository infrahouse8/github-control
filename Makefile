SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help
define BROWSER_PYSCRIPT
import webbrowser
webbrowser.open("docs/_build/html/index.html")
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-40s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT
BROWSER := python -c "$$BROWSER_PYSCRIPT"

help: ## Print this help
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

.PHONY: hooks
hooks:
	test -f .git/hooks/pre-commit || cp hooks/pre-commit .git/hooks/pre-commit


.PHONY: bootstrap
bootstrap: hooks ## Build development environment
	pip install -r requirements.txt

.PHONY: bootstrap-ci
bootstrap-ci:  ## Build environment for CI
	pip install -r requirements-ci.txt


.PHONY: lint/format
lint/format:
	yamllint \
		.github/workflows \
		.readthedocs.yaml
	terraform fmt -check -recursive

.PHONY: lint/validate
lint/validate: init
	terraform validate

.PHONY: lint
lint: lint/format lint/validate ## Check code style and validate Terraform code

.PHONY: format
format:  ## Format terraform files
	terraform fmt -recursive

.PHONY: init
init:
	terraform --version
	terraform init -upgrade

.PHONY: plan
plan: init ## Run terraform plan
	set -o pipefail ; terraform plan -var-file=configuration.tfvars -no-color --out=tf.plan 2> plan.stderr | tee plan.stdout || (cat plan.stderr; exit 1)


.PHONY: apply
apply: ## Run terraform apply
	terraform apply -auto-approve -input=false tf.plan

.PHONY: docs
docs: ## generate Sphinx HTML documentation
	# rm -f docs/modules.rst
#	sphinx-apidoc -o docs/ twindb_backup
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	$(BROWSER) docs/_build/html/index.html

.PHONY: clean
clean: ## Remove generated files
	rm -fr .terraform
	rm -f .terraform.lock.hcl
	rm -f plan.stderr plan.stdout tf.plan
