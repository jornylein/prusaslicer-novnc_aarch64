# Prusaslicer noVNC Docker Container for aarch64 hosts

## Overview

This is a super basic noVNC build using supervisor to serve Prusaslicer in your favorite web browser.
It is based on helfrichmichael's [prusaslicer-novnc](https://github.com/helfrichmichael/prusaslicer-novnc) and is modified to run on an aarch64 host system.

## How to use

You can use the scripts docker_build.sh (builds a docker image called prusaslicer-novnc_aarch64:latest) or build_and_deploy.sh to build and run the docker container in default configuration.

The default run command is: `docker run --detach --volume=prusaslicer-novnc-data:/configs/ --volume=prusaslicer-novnc-prints:/prints/ -p 8080:8080 -e SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt" --name=prusaslicer-novnc prusaslicer-novnc_aarch64:latest`

This will bind `/configs/` in the container to a local volume on my machine named `prusaslicer-novnc-data`. Additionally it will bind `/prints/` in the container to `superslicer-novnc-prints` locally on my machine, it will bind port `8080` to `8080`, and finally, it will provide an environment variable to keep Prusaslicer happy by providing an `SSL_CERT_FILE`.

## Links

[Prusaslicer](https://www.prusa3d.com/prusaslicer/)

[Supervisor](http://supervisord.org/)

[GitHub Source](https://github.com/jornylein/prusaslicer-novnc_aarch64)

[Original GitHub Source](https://github.com/helfrichmichael/prusaslicer-novnc)