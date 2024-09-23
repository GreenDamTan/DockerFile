name=makedie/proxmox_ve
tag=8.2.6
docker build -t $name:$tag .
docker push $name:$tag