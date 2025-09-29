name=makedie/fnos
tag=0.9.29-1142_rootfs
docker build -t $name:$tag -f Dockerfile ../
#docker push $name:$tag
#docker tag $name:$tag $name:latest
#docker push $name:latest