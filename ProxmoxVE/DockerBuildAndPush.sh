name=makedie/proxmox_ve
tag=8.0.4
docker build -t $name:$tag .
docker push $name:$tag