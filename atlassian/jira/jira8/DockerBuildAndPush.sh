docker build -t makedie/jira-software:8.22.4-ubuntu-jdk-11.0.11_9-openj9-0.26.0 .
docker push makedie/jira-software:8.22.4-ubuntu-jdk-11.0.11_9-openj9-0.26.0
docker tag makedie/jira-software:8.22.4-ubuntu-jdk-11.0.11_9-openj9-0.26.0 makedie/jira-software:latest
docker push makedie/jira-software:latest