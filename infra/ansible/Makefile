.PHONY: st, baseline

st: 
	ansible -i inventory.ini k8s -m ping
base:
	ansible-playbook -i inventory.ini baseline.yml
k3-server:
	ansible-playbook -i inventory.ini k3s-server.yml
jellyfin:
	ansible-playbook -i inventory.ini jellyfin.yml
grafana:
	ansible-playbook -i inventory.ini grafana.yml
prometheus:
	ansible-playbook -i inventory.ini prometheus.yml
