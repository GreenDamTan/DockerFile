docker build -t makedie/jenkins:2.346.1-lts-jdk-17.0.3_7-openj9-0.32.0 .
docker push makedie/jenkins:2.346.1-lts-jdk-17.0.3_7-openj9-0.32.0
docker tag makedie/jenkins:2.346.1-lts-jdk-17.0.3_7-openj9-0.32.0 makedie/jenkins:latest
docker push makedie/jenkins:latest