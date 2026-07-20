# Lab Routing

Host IP Role

| Host          | IP             | Role                              |
| ------------- | -------------- | --------------------------------- |
| server router | 192.168.20.1   | Isolated server network           |
| pve-main      | 192.168.20.2   | Proxmox node 1                    |
| k8s-cp-1      | 192.168.20.3   | Proxmox node 1 - Control Plane VM |
| jellyfin      | TODO           | Jellyfin server                   |
| pve-worker    | 192.168.20.100 | Proxmox node 2                    |
| k8s-w-1       | 192.168.20.101 | Proxmox node 2 — worker VM 1      |
| k8s-w-2       | 192.168.20.102 | Proxmox node 2 — worker VM 2      |
| pgdb          | 192.168.20.103 | Proxmox node 3 — pg db            |
