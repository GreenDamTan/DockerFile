name=makedie/proxmox_ve
tag=8.3.2
#DOCKER_BUILDKIT=1 docker build --network host -t $name:$tag .
docker build -t $name:$tag .
docker push $name:$tag