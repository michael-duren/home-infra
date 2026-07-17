.PHONY: st, baseline

st: 
	ansible -i inventory.ini k8s -m ping
baseline:
	ansible-playbook -i inventory.ini baseline.yml
