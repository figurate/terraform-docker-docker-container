SHELL:=/bin/bash
TERRAFORM_VERSION=0.12.24
TERRAFORM=docker run --rm -v "${PWD}:/work" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work hashicorp/terraform:$(TERRAFORM_VERSION)

TERRAFORM_DOCS=docker run --rm -v "${PWD}:/work" tmknom/terraform-docs

CHECKOV=docker run -t -v "${PWD}:/work" bridgecrew/checkov

DIAGRAMS=docker run -t -v "${PWD}:/work" figurate/diagrams python

.PHONY: all clean validate test docs format

all: validate test docs format

clean:
	rm -rf .terraform/

validate:
	$(TERRAFORM) init && $(TERRAFORM) validate && \
		$(TERRAFORM) init modules/packer && $(TERRAFORM) validate modules/packer && \
		$(TERRAFORM) init modules/aws-cli && $(TERRAFORM) validate modules/aws-cli && \
		$(TERRAFORM) init modules/kubectl && $(TERRAFORM) validate modules/kubectl && \
		$(TERRAFORM) init modules/s3cmd && $(TERRAFORM) validate modules/s3cmd && \
		$(TERRAFORM) init modules/git && $(TERRAFORM) validate modules/git

test: validate
	$(CHECKOV) -d /work && \
		$(CHECKOV) -d /work/modules/packer && \
		$(CHECKOV) -d /work/modules/aws-cli && \
		$(CHECKOV) -d /work/modules/kubectl && \
		$(CHECKOV) -d /work/modules/s3cmd && \
		$(CHECKOV) -d /work/modules/git

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(TERRAFORM_DOCS) markdown ./ >./README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/packer >./modules/packer/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/aws-cli >./modules/aws-cli/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/kubectl >./modules/kubectl/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/s3cmd >./modules/s3cmd/README.md && \
		$(TERRAFORM_DOCS) markdown ./modules/git >./modules/git/README.md

format:
	$(TERRAFORM) fmt -list=true ./ && \
		$(TERRAFORM) fmt -list=true ./modules/packer && \
		$(TERRAFORM) fmt -list=true ./modules/aws-cli && \
		$(TERRAFORM) fmt -list=true ./modules/kubectl && \
		$(TERRAFORM) fmt -list=true ./modules/s3cmd && \
		$(TERRAFORM) fmt -list=true ./modules/git
