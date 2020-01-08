TAG := $(shell git rev-parse --short HEAD)

# HELP
# This will output the help for each task
.PHONY: help ss7 clean

help: ## Show help with available targets.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e  's/##//'

test: ## Target to test something in Makefile
	@echo tag is $(TAG)

.DEFAULT_GOAL := help

ss7: ## Build ss7 docker image and save as ss7-img.tar.gz.
ss7: ss7-img.tar.gz

ss7-img.tar.gz: ss7-img.id
	docker save $(shell cat $<) | pigz -c > $@
	docker tag $(shell cat $<) ss7:$(TAG)
	docker create -it --mac-address 0c:c4:7a:d8:a5:42 --network vlan_349 --name ss7 $(shell cat $<)
	docker network connect vlan_338 ss7
ss7-img.id:
	docker build --iidfile $@ .

#ss7: Dockerfile
#	docker build $@ .

clean: ## Remove builded artifacts.
	rm ss7-img.tar.gz
	rm ss7-img.id
