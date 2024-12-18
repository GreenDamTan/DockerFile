name=makedie/fnos
tag=0.8.27-551_test
docker build -t $name:$tag .
docker push $name:$tag
docker tag $name:$tag $name:latest
docker push $name:latest