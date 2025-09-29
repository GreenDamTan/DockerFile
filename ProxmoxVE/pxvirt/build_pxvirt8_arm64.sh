name=makedie/proxmox_ve
tag=pxvirt-8.4.10-arm64
docker buildx build --platform=linux/arm64 -t $name:$tag -f pxvirt8_amd64.dockerfile ../
docker push $name:$tag