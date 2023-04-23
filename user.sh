script_path=$(dirname $0)
source ${script_path}/common.sh
exit

echo -e "\e[31m>>>>>>>>>>>Setup NodeJS repo<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m>>>>>>>>>>>Install NodeJS<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[31m>>>>>>>>>>>Add app User<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m>>>>>>>>>>>setup an app directory<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[31mOk\e[0m"

echo -e "\e[31m>>>>>>>>>>>Download the app code<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip

echo -e "\e[31m>>>>>>>>>>>download the dependencies<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[31m>>>>>>>>>>>Copy SystemD User Service<<<<<<<<<<<<<<\e[0m"
cp /root/roboshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[31m>>>>>>>>>>>Load the service<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user

echo -e "\e[31m>>>>>>>>>>>Copy MongoDB repo<<<<<<<<<<<<<<\e[0m"
cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>>>>>Installing mongodb-client repo<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>>>>>>>>>Load Schema<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.smitdevops.online </app/schema/user.js

