name=makedie/fastapi-dls
tag=1.5.4
docker build -t $name:$tag .
docker push $name:$tag