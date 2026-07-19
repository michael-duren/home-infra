.PHONY: st, baseline

st: 
	ansible -i inventory.ini k8s -m ping
base:
	ansible-playbook -i inventory.ini baseline.yml
k3-server:
	ansible-playbook -i inventory.ini k3s-server.yml
