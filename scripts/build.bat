@echo off

rem apollo config db info
set apollo_config_db_url="jdbc:mysql://mysql-s1.wd.net:3306/apollo_config?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false"
set apollo_config_db_username="dev_user"
set apollo_config_db_password="DBdev-jiarui"
#set apollo_config_db_url="jdbc:mysql://192.168.100.181:3306/apollo_config?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false"
#set apollo_config_db_username="dev_user"
#set apollo_config_db_password="DBdev-jiarui"

rem apollo portal db info
#set apollo_portal_db_url="jdbc:mysql://mysql-s1.wd.net:3306/apollo_portal?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false"
#set apollo_portal_db_username="dev_user"
#set apollo_portal_db_password="DBdev-jiarui"

set apollo_portal_db_url="jdbc:mysql://192.168.100.181:3306/apollo_portal?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false"
set apollo_portal_db_username="dev_user"
set apollo_portal_db_password="DBdev-jiarui"

rem meta server url, different environments should have different meta server addresses
set dev_meta="http://192.168.100.21:9900"
set fat_meta="http://192.168.100.200:9900"
set pro_meta="http://47.95.242.151:9900"

set META_SERVERS_OPTS=-Ddev_meta=%dev_meta% -Dfat_meta=%fat_meta% -Duat_meta=%uat_meta% -Dpro_meta=%pro_meta%

rem =============== Please do not modify the following content =============== 
rem go to script directory
cd "%~dp0"

cd ..

rem package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

call mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=%apollo_config_db_url% -Dspring_datasource_username=%apollo_config_db_username% -Dspring_datasource_password=%apollo_config_db_password%

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

call mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=%apollo_portal_db_url% -Dspring_datasource_username=%apollo_portal_db_username% -Dspring_datasource_password=%apollo_portal_db_password% %META_SERVERS_OPTS%

echo "==== building portal finished ===="

pause
