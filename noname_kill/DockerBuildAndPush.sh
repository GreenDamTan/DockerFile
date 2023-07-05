name=makedie/noname_kill
tag=v1.9.122.3
docker build -t $name:$tag .
docker push $name:$tag
docker tag $name:$tag $name:latest
docker push $name:latest