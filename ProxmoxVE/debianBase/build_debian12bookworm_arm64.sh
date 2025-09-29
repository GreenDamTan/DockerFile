name=makedie/proxmox_ve
tag=debian-bookworm-20250630-arm64
docker buildx build --platform=linux/arm64 -t $name:$tag -f debian12bookworm.dockerfile .
docker push $name:$tag