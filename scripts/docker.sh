#!/usr/bin/env bash

# https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/
brew install docker docker-compose docker-machine xhyve docker-machine-driver-xhyve

sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

docker-machine create default --driver xhyve --xhyve-experimental-nfs-share

eval $(docker-machine env default)
