.PHONY: ping

ping:
	ansible -m ping vms -i ansible/inventory/on-prem.yml

vms: # Install common on a particular set of hosts (--limit)
	ansible-playbook ansible/common.yml \
		-i ansible/inventory/on-prem.yml \
		--limit vms \
		--ask-become-pass

.PHONY: debug
debug: # Dry run
	ansible-playbook ansible/common.yml \
		-i ansible/inventory/on-prem.yml \
		--limit template \
		--check \
		--diff \
		--ask-become-pass
