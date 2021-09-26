##################################################################
# Script Name	: docker-start.sh
# Description	: Used to start both nginx and stunnel
# Args          : none
# Author       	: dudoleitor
# Email         : dudoleitor@dudoleitor.com
# GitHub        : github.com/dudoleitor/docker-nginx-rtmps
###################################################################

#!/bin/sh
/usr/bin/stunnel

# nginx won't daemonize so that docker can detect
# the process running inside the container
/usr/local/nginx/sbin/nginx -g 'daemon off;'
