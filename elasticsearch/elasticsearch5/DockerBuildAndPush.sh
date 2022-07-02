docker build -t makedie/elasticsearch:5.6.16-jdk-8u332-b09-openj9-0.32.0 .
docker push makedie/elasticsearch:5.6.16-jdk-8u332-b09-openj9-0.32.0
docker tag makedie/elasticsearch:5.6.16-jdk-8u332-b09-openj9-0.32.0 makedie/elasticsearch:latest
docker push makedie/elasticsearch:latest