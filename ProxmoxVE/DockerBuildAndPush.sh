#docker build --squash -t makedie/proxmox_ve:7.2-1 .
docker build -t makedie/proxmox_ve:7.3-3 .
docker push makedie/proxmox_ve:7.3-3
docker tag makedie/proxmox_ve:7.3-3 makedie/proxmox_ve:latest
docker push makedie/proxmox_ve:latest