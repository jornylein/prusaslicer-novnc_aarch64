#!/bin/bash
  
./docker_build.sh

docker volume create prusaslicer-novnc-data
docker volume create prusaslicer-novnc-prints
docker run --detach --volume=prusaslicer-novnc-data:/configs/ --volume=prusaslicer-novnc-prints:/prints/ -p 8080:8080 -e SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt" --name=prusaslicer-novnc prusaslicer-novnc_aarch64:latest