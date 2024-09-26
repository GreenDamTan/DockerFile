docker build -t makedie/fnos:0.8.20_test .
docker push makedie/fnos:0.8.20_test
docker tag makedie/fnos:0.8.20_test makedie/fnos:latest
docker push makedie/fnos:latest