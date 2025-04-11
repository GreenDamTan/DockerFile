name=makedie/noname_kill
tag=v1.10.17.1
docker build -t $name:$tag .
docker push $name:$tag
docker tag $name:$tag $name:latest
docker push $name:latest