echo -e "\e[31m>>>>>>>>>>>>>Setup NodeJS repos<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m>>>>>>>>>>>>>Install NodeJS<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[31m>>>>>>>>>>>>>Add application User<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[31m>>>>>>>>>>>>>setup an app directory<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>>>>>>Download app content<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app


echo -e "\e[31m>>>>>>>>>>>>>Unzip App content<<<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[31m>>>>>>>>>>>>>Download the dependencies<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[31m>>>>>>>>>>>>>Setup a new service in systemd<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m>>>>>>>>>>>>>Load the service<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[31m>>>>>>>>>>>>>Setup MongoDB repo<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>>>>>>>Iinstall mongodb-client<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>>>>>>>>>>>Load Schema<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.smitdevops.com </app/schema/catalogue.js