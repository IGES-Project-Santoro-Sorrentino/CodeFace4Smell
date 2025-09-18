#!/bin/bash

docker stop codeface4smell
docker rm codeface4smell

docker build . -t codeface4smell
if [ $? -ne 0 ]; then
  echo "Docker build failed. Stopping script."
  exit 1
fi

docker run -dit --name codeface4smell -p 8080:8081 -p 8081:8081 -p 22:22 -p 3306:3306 codeface4smell

docker exec -it codeface4smell bash -c "./start_server.sh && codeface -j8 run -c codeface.conf -p conf/qemu.conf results/ git-repos/ && ./deploy-shiny-nginx.sh; exec bash"