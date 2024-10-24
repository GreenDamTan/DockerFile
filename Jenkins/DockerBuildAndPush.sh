name=makedie/jenkins
tag=2.462.3-lts-jdk17-openj9-17.0.12.1_7-jdk
docker build -t $name:$tag .
docker push $name:$tag
docker tag $name:$tag $name:latest
docker push $name:latest