.PHONY: rebuild

rb:
	cd tf && tofu apply -auto-approve
	cd ansible && ansible-playbook -i inventory.ini baseline.yml
