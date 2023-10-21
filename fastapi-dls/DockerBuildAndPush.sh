name=makedie/fastapi-dls
tag=1.3.9
docker build -t $name:$tag .
docker push $name:$tag