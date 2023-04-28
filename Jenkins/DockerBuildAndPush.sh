docker build -t makedie/jenkins:2.387.2-lts-jdk17-openj9 .
docker push makedie/jenkins:2.387.2-lts-jdk17-openj9
docker tag makedie/jenkins:2.387.2-lts-jdk17-openj9 makedie/jenkins:latest
docker push makedie/jenkins:latest