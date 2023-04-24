script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_pwd=$1


echo -e "\e[31m>>>>>>>>>>>>>>Install Maven<<<<<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[31m>>>>>>>>>>>>>>Add app user<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[31m>>>>>>>>>>>>>>setup an app directory<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>>>>>>>Download app code<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[31m>>>>>>>>>>>>>>Unzip app code<<<<<<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[31m>>>>>>>>>>>>>>Download Maven dependencies<<<<<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[31m>>>>>>>>>>>>>>Copy service file<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m>>>>>>>>>>>>>>Install MYSQL Client<<<<<<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[31m>>>>>>>>>>>>>>load schema to the DB.<<<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.smitdevops.online -uroot -p${mysql_pwd} < /app/schema/shipping.sql

echo -e "\e[31m>>>>>>>>>>>>>>Load the service<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping