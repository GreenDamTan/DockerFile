name=makedie/noname_kill
tag=v1.10.15.1
docker build -t $name:$tag .
docker push $name:$tag
docker tag $name:$tag $name:latest
docker push $name:latest