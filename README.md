# docker-nginx-rtmps
Using this container you can stream simultaneously to multiple rtmps destinations, for the time being it pushes the feed to YouTube and Facebook live.
- Docker-hub image: [dudoleitor/nginx-rtmps](https://hub.docker.com/repository/docker/dudoleitor/nginx-rtmps)



## Description
### Use cases
A lot of streaming software (such as the popular [OBS](https://obsproject.com/)) is capable of streaming to a single destination only and you may have the need to publish your live to more than just one social network at the same time. Sure you can install a plugin to accomplish this, but you are increasing the load on the same hardware that is already under stress.
In addition to this, you can use a docker container to split the stream coming from dedicated video switchers that may not support multiple destinations (for example the [ATEM Mini by Blackmagic](https://www.blackmagicdesign.com/products/atemmini)).

### What does the container do
Inside the docker container runs [nginx](https://www.nginx.com/), a popular *web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache*. The webserver receives the stream coming from your device and is capable of pushing it back to multiple destinations. The rtmp engine sends the feed (using the rtmp protocol) to an [stunnel](https://www.stunnel.org/) daemon which encrypts it so that it can be sent out as rtmps. Stunnel is specifically designed to *add TLS encryption functionality without any changes in the programs' code* so works perfectly after nginx.



## How to use
0. First of all, open Youtube and Facebook live
1. Paste your streaming keys into the proper configuration file: download [`nginx.conf`](https://github.com/Dudoleitor/docker-nginx-rtmps/blob/main/nginx.conf) (`wget https://raw.githubusercontent.com/Dudoleitor/docker-nginx-rtmps/main/nginx.conf`) and open it with your favourite text editor (`nano nginx.conf`)
  - Replace `YouTube_key_here` and `Facebook_key_here` accordingly (without the `/` at the end!)
2. Now start the container mouting the file you just edited and forwarding the input port 1935 tcp:
```bash
  docker run -d -p 1935:1935 -v /path/to/edited/file/nginx.conf:/usr/local/nginx/conf/nginx.conf:ro dudoleitor/nginx-rtmps
```
3. Configure your streaming software and start the live feed:
```
  - Server: rtmp://yourIP:1935/live
  - Streaming key: (leave blank)
```
  - yourIP should be the address your container is listening on, be sure to properly configure port-forwarding on your firewall to allow connections on port 1935 TCP.
4. Done! Both YouTube and Facebook should now be receveing your feed.

### Security note!
Please be aware that any connection to *rtmp://yourip/live* will be accepted by nginx, this means anyone can connect to your stream without proper security measures. You could edit the configuration file to set up a custom input streaming key or configure the firewall to allow only trusted IPs.

### Throubleshooting
If you need to open a shell inside the container while it's running, first get the instance name using `docker ps` and then run
```bash
docker exec -it containerID bash
```


## Advanced notes
The container is pushing the feed to *rtmps://a.rtmps.youtube.com:443/live2* and to *rtmps://live-api-s.facebook.com:443/rtmp/*.

If you need to change the default behaviour, follow this steps:
1. Download and edit the [stunnel.conf](https://github.com/Dudoleitor/docker-nginx-rtmps/blob/main/build-scripts/stunnel.conf) file, you can change the destination servers and/or add another service
2. Edit the [nginx configuration](https://github.com/Dudoleitor/docker-nginx-rtmps/blob/main/nginx.conf), you need a *push* directive for each destination (use ports 1935x for the local sockets, matching the stunnel configuration); if you do not want to use rtmps (defaulting to rtmp) skip the stunnel part and configure the final url directly in the nginx.conf file
3. Download the [Dockerfile](https://github.com/Dudoleitor/docker-nginx-rtmps/blob/main/build-scripts/Dockerfile) and the [docker-start.sh](https://github.com/Dudoleitor/docker-nginx-rtmps/blob/main/build-scripts/docker-start.sh) file, build your custom image with `docker build -t yourImageName /path/to/Dockerfile`, be sure to have the *stunnel.conf* and *docker-start.sh* files in your working directory
4. Start the container replacing *dudoleitor/nginx-rtmps* with your custom image name.



## Similar projects and guides
### Why this project is (a little) different from the others online
On the internet there are a lot of examples and guides to help you split a video stream but the majority of them does not support rtmps. Please note that Facebook live recently blocked non-encrypted traffic (rtmp) allowing only rtmps.
Because of this this, I decided to develop a docker container capable of dealing with multple streams and rtmps. Why a docker container? In this case, because it's very easy to start it, just have a few lines of configuration and it can be up and running within minutes.

### Useful links
I was inspired by this [project](https://github.com/tiangolo/nginx-rtmp-docker) from [Sebastián Ramírez @tiangolo](https://github.com/tiangolo); [this guide](https://www.nginx.com/blog/video-streaming-for-remote-learning-with-nginx/) on the official nginx blog helped me install and configure nginx. If you need to understand how the link between nginx and stunnel work, I suggest you to check out [this article](https://dev.to/lax/rtmps-relay-with-stunnel-12d3) on dev.to.


## License
This project is licensed under the terms of the MIT License.

