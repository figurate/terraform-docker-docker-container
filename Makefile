SHELL:=/bin/bash
AWS_DEFAULT_REGION?=ap-southeast-2

TERRAFORM_VERSION=0.13.4
TERRAFORM=docker run --rm -v "${PWD}:/work" -v "${HOME}:/root" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work hashicorp/terraform:$(TERRAFORM_VERSION)

TERRAFORM_DOCS=docker run --rm -v "${PWD}:/work" tmknom/terraform-docs

CHECKOV=docker run --rm -v "${PWD}:/work" bridgecrew/checkov

TFSEC=docker run --rm -v "${PWD}:/work" liamg/tfsec

DIAGRAMS=docker run -v "${PWD}:/work" figurate/diagrams python

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test docs format

all: validate test docs format

clean:
	rm -rf .terraform/

validate:
	$(TERRAFORM) init && $(TERRAFORM) validate && \
		$(TERRAFORM) init modules/packer && $(TERRAFORM) validate modules/packer && \
		$(TERRAFORM) init modules/python && $(TERRAFORM) validate modules/python && \
		$(TERRAFORM) init modules/awscli && $(TERRAFORM) validate modules/awscli && \
		$(TERRAFORM) init modules/ecr && $(TERRAFORM) validate modules/ecr && \
		$(TERRAFORM) init modules/kubectl && $(TERRAFORM) validate modules/kubectl && \
		$(TERRAFORM) init modules/s3cmd && $(TERRAFORM) validate modules/s3cmd && \
		$(TERRAFORM) init modules/git && $(TERRAFORM) validate modules/git && \
		$(TERRAFORM) init modules/gradle && $(TERRAFORM) validate modules/gradle

test: validate
	$(CHECKOV) -d /work

	$(TFSEC) /work

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(TERRAFORM_DOCS) markdown ./ >./README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/packer >./modules/packer/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/python >./modules/python/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/awscli >./modules/awscli/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/ecr >./modules/ecr/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/kubectl >./modules/kubectl/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/s3cmd >./modules/s3cmd/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/git >./modules/git/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/gradle >./modules/gradle/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/packer && \
		$(TERRAFORM) fmt -list=true ./modules/python && \
		$(TERRAFORM) fmt -list=true ./modules/awscli && \
		$(TERRAFORM) fmt -list=true ./modules/ecr && \
		$(TERRAFORM) fmt -list=true ./modules/kubectl && \
		$(TERRAFORM) fmt -list=true ./modules/s3cmd && \
		$(TERRAFORM) fmt -list=true ./modules/git && \
		$(TERRAFORM) fmt -list=true ./modules/gradle && \
		$(TERRAFORM) fmt -list=true ./examples/apachesling && \
		$(TERRAFORM) fmt -list=true ./examples/ghost && \
		$(TERRAFORM) fmt -list=true ./examples/minio

example:
	$(TERRAFORM) init examples/$(EXAMPLE) && $(TERRAFORM) plan examples/$(EXAMPLE)
