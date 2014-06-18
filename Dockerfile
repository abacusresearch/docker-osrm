FROM ubuntu:12.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential cmake pkg-config libprotoc-dev protobuf-compiler libprotobuf-dev libosmpbf-dev libpng12-dev libbz2-dev libstxxl-dev libxml2-dev libzip-dev libboost-all-dev liblua5.1-0-dev libluabind-dev

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install git
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install libboost-all-dev


RUN mkdir -p /osrm
RUN mkdir -p /data
RUN git clone https://github.com/DennisOSRM/Project-OSRM.git /osrm/project-osrm 
RUN cd /osrm/project-osrm && git checkout v0.3.10

RUN mkdir -p /osrm/project-osrm/build

ADD server.ini /osrm/project-osrm/server.ini

WORKDIR /osrm/project-osrm/build
RUN cmake ..
RUN make -j8

MAINTAINER Philipp Hug <philipp@hug.cx>
VOLUME /data
EXPOSE 5000
CMD ["/osrm/project-osrm/build/osrm-routed", "/data/planet-latest.osrm", "-c", "/osrm/project-osrm/server.ini"]

