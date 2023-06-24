docker build -t makedie/noname_kill:v1.9.121 .
docker push makedie/noname_kill:v1.9.121
docker tag makedie/noname_kill:v1.9.121 makedie/noname_kill:latest
docker push makedie/noname_kill:latest