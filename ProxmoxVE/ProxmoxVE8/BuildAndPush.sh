name=makedie/proxmox_ve
tag=8.4.5
#DOCKER_BUILDKIT=1 docker build --network host -t $name:$tag .
docker build -t $name:$tag -f Dockerfile ../
docker push $name:$tag