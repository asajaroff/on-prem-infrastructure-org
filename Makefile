.PHONY: help
.DEFAULT_GOAL := help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: ping
ping: ## Ping all hosts in the inventory
	@ansible -m ping vms -i ansible/inventory/amsterdam.yml

common: # Install common on a particular set of hosts (--limit)
	@echo "ansible-playbook ansible/common.yml \
		-i ansible/inventory/amsterdam.yml \
		--limit vms \
		--ask-become-pass"

haproxy: ## HAProxy installation step
	ansible-playbook ansible/common.yml \
		-i ansible/inventory/amsterdam.yml

docker: # Set up the `podman-machine`
	ansible-playbook ansible/docker.yml \
		-i ansible/inventory/amsterdam.yml

.PHONY: debug
debug: # Dry run
	ansible-playbook ansible/common.yml \
		-i ansible/inventory/amsterdam.yml \
		--limit template \
		--check \
		--diff
