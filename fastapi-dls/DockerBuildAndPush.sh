name=makedie/fastapi-dls
tag=2.0.2
docker build -t $name:$tag .
docker push $name:$tag