.PHONY: rebuild

destroy:
	cd tf && tofu destroy -target=module.k8s_cp_1

buildbase:
	cd tf && tofu apply -auto-approve
	cd ansible && ansible-playbook -i inventory.ini baseline.yml
