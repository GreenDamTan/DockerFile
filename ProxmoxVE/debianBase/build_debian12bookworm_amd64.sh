name=makedie/proxmox_ve
tag=debian-bookworm-20250407
docker build -t $name:$tag .
docker push $name:$tag