docker build -t makedie/fnos:0.8.23-458_test .
docker push makedie/fnos:0.8.23-458_test
docker tag makedie/fnos:0.8.23-458_test makedie/fnos:latest
docker push makedie/fnos:latest