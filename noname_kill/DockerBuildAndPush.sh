docker build -t makedie/noname_kill:v1.9.114.3.1 .
docker push makedie/noname_kill:v1.9.114.3.1
docker tag makedie/noname_kill:v1.9.114.3.1 makedie/noname_kill:latest
docker push makedie/noname_kill:latest