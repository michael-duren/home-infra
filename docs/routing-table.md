# Lab Routing

Host IP Role

| Host          | IP           | Role                                         |
| ------------- | ------------ | -------------------------------------------- |
| server router | 192.168.20.1 | Isolated server network                      |
| pve-main      | 192.168.20.2 | Proxmox node 1 — services + control plane VM |
| jellyfin      | TODO         | Jellyfin server                              |
| pve-worker    | TODO         | Proxmox node 2 — worker VMs                  |
| k8s-cp-1      | TODO         | Kubernetes control plane (VM)                |
| k8s-w-1       | TODO         | Kuberentes worker (VM)                       |
| k8s-w-2       | TODO         | Proxmox node 1 — services + control plane VM |
