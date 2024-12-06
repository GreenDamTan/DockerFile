docker build -t makedie/fnos:0.8.26-516_test .
docker push makedie/fnos:0.8.26-516_test
docker tag makedie/fnos:0.8.26-516_test makedie/fnos:latest
docker push makedie/fnos:latest