##################################################################
# File Name     : DockerFile
# Description	: Used to build the container (docker build -t <imagename> <filepath>)
# Args          : none
# Author       	: dudoleitor
# Email         : dudoleitor@dudoleitor.com
# GitHub        : github.com/dudoleitor/docker-nginx-rtmps
###################################################################

FROM buildpack-deps:bullseye

LABEL org.opencontainers.image.source=https://github.com/dudoleitor/docker-nginx-rtmps
LABEL org.opencontainers.image.authors="dudoleitor dudoleitor@dudoleitor.com"

# Installing nginx with rtmp module (cloning from the official github)
RUN cd /tmp && \
git clone https://github.com/arut/nginx-rtmp-module.git && \
git clone https://github.com/nginx/nginx.git && \
cd nginx && \
./auto/configure --add-module=../nginx-rtmp-module && \
make && \
make install && \
rm -r /tmp/*

# Installing stunnel using apt package manager
RUN apt update && apt install stunnel4 -y

#Copying configurations
COPY stunnel.conf /etc/stunnel/stunnel.conf


# Start script, used to run both nginx and stunnel
COPY docker-start.sh /docker-start.sh

CMD /docker-start.sh
