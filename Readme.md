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

`docker build -t wso2is:5.5.0 .`
    
##### 4. Modify .

change carbon.xml at your needs

##### 5. Run
```
docker run \
-p 9444:9444 \
--volume ./carbon.xml:/home/wso2carbon/wso2is-5.5.0/repository/conf/carbon.xml \
wso2is:5.5.0
```
