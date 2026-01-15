#!/bin/bash

docker stop codeface4smell
docker rm codeface4smell

docker build . -t codeface4smell
if [ $? -ne 0 ]; then
  echo "Docker build failed. Stopping script."
  exit 1
fi

docker run -dit --name codeface4smell -p 8080:8081 -p 8081:8081 -p 22:22 codeface4smell

docker exec -it codeface4smell bash -c "./start-server.sh && codeface -j8 run -c codeface.conf -p conf/qemu.conf results/ git-repos/ && ./start-dashboard.sh; exec bash"
# codeface ml -c codeface.conf -p conf/qemu.conf -m gmane.comp.emulators.qemu results/qemu/ml mldir/
# codeface st -c codeface.conf -p conf/qemu.conf results/qemu/