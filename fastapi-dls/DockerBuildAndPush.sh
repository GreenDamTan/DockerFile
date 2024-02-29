name=makedie/fastapi-dls
tag=1.3.10
docker build -t $name:$tag .
docker push $name:$tag