script=$(realpath $0)
realpath $0


script_path=$(dirname $0)
source ${script_path}/common.sh

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
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip

echo -e "\e[31m>>>>>>>>>>>download the dependencies<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[31m>>>>>>>>>>>Copy SystemD User Service<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/cart.service /etc/systemd/system/cart.service

echo -e "\e[31m>>>>>>>>>>>Load the service<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart



