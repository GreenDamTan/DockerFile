name=makedie/fastapi-dls
tag=1.3.5
docker build -t $name:$tag .
docker push $name:$tag