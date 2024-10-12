.PHONY: help
.DEFAULT_GOAL := help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: ping
ping: ## Ping all hosts in the inventory
	@ansible -m ping vms -i ansible/inventory/amsterdam.yml

bootstrap: ## Install common on a particular set of hosts (--limit) - Run as `make bootstrap TARGET_HOST=host.example.com`
	ansible-playbook ansible/common.yml \
		-i ansible/inventory/amsterdam.yml \
		--limit ${TARGET_HOST} \
		--ask-become-pass

haproxy: haproxy-validate ## HAProxy installation step
	ansible-playbook ansible/haproxy.yml \
		-i ansible/inventory/amsterdam.yml

haproxy-validate: ## Validates HAProxy configuration
	podman run \
		-v ./ansible/roles/haproxy/templates/haproxy.cfg.j2:/etc/haproxy/haproxy.cfg \
		-v ./ansible/roles/haproxy/templates/errors/:/etc/haproxy/errors/ \
		-v ./ansible/roles/haproxy/templates/cert.pem:/etc/haproxy/certs/ams.molest.ar.pem \
		docker.io/haproxy:2.6-bookworm  \
		-c -V -f /etc/haproxy/haproxy.cfg

docker: ## Set up the `podman-machine`
	ansible-playbook ansible/docker.yml \
		-i ansible/inventory/amsterdam.yml

.PHONY: debug
common: ## Dry run
	ansible-playbook ansible/common.yml \
		-i ansible/inventory/amsterdam.yml \
		--limit template \
		--check \
		--diff \
		--ask-become-pass
