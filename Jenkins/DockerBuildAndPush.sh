name=makedie/jenkins
tag=2.492.2-lts-jdk17-openj9-17.0.14_7-jdk
docker build -t $name:$tag .
docker push $name:$tag
docker tag $name:$tag $name:latest
docker push $name:latest