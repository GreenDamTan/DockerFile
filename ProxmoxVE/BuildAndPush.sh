name=makedie/proxmox_ve
tag=8.3.3
#DOCKER_BUILDKIT=1 docker build --network host -t $name:$tag .
docker build -t $name:$tag .
docker push $name:$tag