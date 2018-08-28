#!/bin/sh
# ------------------------------------------------------------------------
# This file have heavily based on https://github.com/wso2/docker-is
# go there if you need kubernetes and the staff
#
# Copyright 2018 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------
set +e

# custom WSO2 non-root user and group variables
user=wso2carbon
group=wso2

# file path variables
volumes=${WORKING_DIRECTORY}/volumes

# capture the Docker container IP from the container's /etc/hosts file
#docker_container_ip=$(awk 'END{print $1}' /etc/hosts)

# check if the WSO2 non-root user home exists
test ! -d ${WORKING_DIRECTORY} && echo "WSO2 Docker non-root user home does not exist" && exit 1

# check if the WSO2 product home exists
test ! -d ${WSO2_SERVER_HOME} && echo "WSO2 Docker product home does not exist" && exit 1

# copy configuration changes and external libraries

# check if any changed configuration files have been mounted
# if any file changes have been mounted, copy the WSO2 configuration files recursively
test -d ${volumes}/ && cp -r ${volumes}/* ${WSO2_SERVER_HOME}/

# make any runtime or node specific configuration changes
# for example, setting container IP in relevant configuration files

# set the Docker container IP as the `localMemberHost` under axis2.xml clustering configurations (effective only when clustering is enabled)
#sed -i "s#<parameter\ name=\"localMemberHost\".*<\/parameter>#<parameter\ name=\"localMemberHost\">${docker_container_ip}<\/parameter>#" ${WSO2_SERVER_HOME}/repository/conf/axis2/axis2.xml


#modify the localhost to domain
if [ "${WSO2_SERVER_HOST}" != "localhost" ];
then 
grep -rlZ localhost ${WSO2_SERVER_HOME} | xargs -r -0 sed -i s@localhost@${WSO2_SERVER_HOST}@g || true

#fix rmi issues
grep -rlZ rmi://${WSO2_SERVER_HOST} ${WSO2_SERVER_HOME} | xargs -r -0 sed -i s@rmi://${WSO2_SERVER_HOST}@rmi://localhost@g || true

sed -i "s/${WSO2_SERVER_HOST}/localhost/g" ${WSO2_SERVER_HOME}/repository/conf/etc/jmx.xml

#fix ldap issues

sed -i "s/${WSO2_SERVER_HOST}/localhost/g"  ${WSO2_SERVER_HOME}/repository/conf/user-mgt.xml

fi

if [ "${PROXY_PORT}" = "443" ];
then
sed -i '/port="9443"/a proxyPort="443"' ${WSO2_SERVER_HOME}/repository/conf/tomcat/catalina-server.xml

sed -i "s/\"proxyHost\" : \"\"/\"proxyHost\" : \"${WSO2_SERVER_HOST}\"/g" ${WSO2_SERVER_HOME}/repository/deployment/server/jaggeryapps/portal/conf/site.json

sed -i "s/\"proxyHTTPSPort\" : \"\"/\"proxyHTTPSPort\"\ :\ \"443\"/g" ${WSO2_SERVER_HOME}/repository/deployment/server/jaggeryapps/portal/conf/site.json

sed -i "s/\"proxyHost\" : \"\"/\"proxyHost\" : \"${WSO2_SERVER_HOST}\"/g" ${WSO2_SERVER_HOME}/repository/deployment/server/jaggeryapps/dashboard/conf/site.json

sed -i "s/\"proxyHTTPSPort\" : \"\"/\"proxyHTTPSPort\"\ :\ \"443\"/g" ${WSO2_SERVER_HOME}/repository/deployment/server/jaggeryapps/dashboard/conf/site.json

fi

# start the WSO2 Carbon server
sh ${WSO2_SERVER_HOME}/bin/wso2server.sh

