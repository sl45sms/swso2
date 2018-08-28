# Dockerfile for WSO2 Identity Server 
####### for standallone or docker swarm

* This repo have heavily based on `https://github.com/wso2/docker-is` go there if you need kubernetes and the staff

##### 1. Checkout the repository 
```
git clone https://github.com/sl45sms/swso2.git
```
##### 2. Download requirements
- Download [JDK 1.8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
and extract it to `./files`.
- Download the WSO2 Identity Server 5.5.0 distribution (https://wso2.com/identity-and-access-management)
and extract it to `./files`. <br>
- Download [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) v5.1.45 and then copy that to `./files` folder

##### 3. Build .

`docker build -t wso2is:5.6.0 .`
    

##### 4. parameters

You can use the enviroment variable 

WSO2_SERVER_HOST

to set the host name

in that case you must change the keystores and mount them as volumes

and the 

PROXY_PORT

if you wont to use reverse proxy

##### 5. Run
```
docker run \
-p 9443:9443 \
wso2is:5.6.0
```
