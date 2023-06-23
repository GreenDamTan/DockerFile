#docker build --squash -t makedie/proxmox_ve:8.0.3 .
docker build -t makedie/proxmox_ve:8.0.3 .
docker push makedie/proxmox_ve:8.0.3
#docker tag makedie/proxmox_ve:8.0.3 makedie/proxmox_ve:latest
#docker push makedie/proxmox_ve:latest