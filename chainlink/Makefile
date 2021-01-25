export NOMAD_ADDR := https://server.global.nomad:4646
export NOMAD_CACERT := $(CURDIR)/nomad-ca/nomad-ca.pem
export NOMAD_CLIENT_CERT := $(CURDIR)/nomad-ca/nomad-client.pem
export NOMAD_CLIENT_KEY := $(CURDIR)/nomad-ca/nomad-client-key.pem

.PHONY: setup
setup:
	make init; make create-infra; make playbook

.PHONY: init	
init:
	pip install -r py_requirements.txt; ansible-galaxy install -r ansible/requirements.yml; cd infrastructure; terraform init

.PHONY: playbook
playbook:
	cd ansible/; ANSIBLE_SSH_RETRIES=5 ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i inventory.yml -K nomad.yml

.PHONY: deploy
deploy:
	cd ansible/; ANSIBLE_SSH_RETRIES=5 ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i inventory.yml nomad.yml --tags "deploy,hostname" -K

.PHONY: volumes
volumes:
	cd ansible/; ANSIBLE_SSH_RETRIES=5 ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i inventory.yml nomad.yml --tags volume

.PHONY: create-infra
create-infra:
	cd infrastructure/; terraform apply

.PHONY: destroy-infra
destroy-infra:
	cd infrastructure/; terraform destroy

.PHONY: stop
stop:
	-nomad stop chainlink
	-nomad stop eth-client
	-nomad stop monitoring
	-nomad stop postgres-master
	-nomad stop postgres-slave
	-nomad stop syntropy-agent
	-nomad system gc
	-make stop-bastion

.PHONY: stop-bastion
stop-bastion:
	-docker stop coredns
	-docker stop syntropy-agent

.PHONY: status
status:
	nomad job status	
