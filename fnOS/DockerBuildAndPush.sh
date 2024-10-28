docker build -t makedie/fnos:0.8.22-438_test .
docker push makedie/fnos:0.8.22-438_test
docker tag makedie/fnos:0.8.22-438_test makedie/fnos:latest
docker push makedie/fnos:latest