name=makedie/proxmox_ve
tag=debian-bookworm-20250630-amd64
docker build -t $name:$tag -f debian12bookworm.dockerfile .
docker push $name:$tag