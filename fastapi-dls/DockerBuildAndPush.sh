name=makedie/fastapi-dls
tag=1.4.1
docker build -t $name:$tag .
docker push $name:$tag