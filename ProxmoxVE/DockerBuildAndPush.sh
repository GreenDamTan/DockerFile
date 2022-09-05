docker build -t makedie/proxmox_ve:7.2-1 .
docker push makedie/proxmox_ve:7.2-1
docker tag makedie/proxmox_ve:7.2-1 makedie/proxmox_ve:latest
docker push makedie/proxmox_ve:latest