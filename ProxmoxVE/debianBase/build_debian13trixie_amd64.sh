name=makedie/proxmox_ve
tag=debian-trixie-20250630-amd64
docker build -t $name:$tag -f debian13trixie.dockerfile .
docker push $name:$tag