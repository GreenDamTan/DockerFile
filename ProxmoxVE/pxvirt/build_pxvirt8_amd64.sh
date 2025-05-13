name=makedie/proxmox_ve
tag=pxvirt-8.4.1-amd64
docker build -t $name:$tag -f pxvirt8_amd64.dockerfile ../
docker push $name:$tag