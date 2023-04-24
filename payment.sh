script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_appuser_pwd=$1


echo -e "\e[31m>>>>>>>>>>>Install Python 3.6<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[31m>>>>>>>>>>>Add app user<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m>>>>>>>>>>>Add app directory<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>>>>Download the app code<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

echo -e "\e[31m>>>>>>>>>>>unzip the app code<<<<<<<<<<\e[0m"
unzip /tmp/payment.zip

echo -e "\e[31m>>>>>>>>>>>Download dependencies<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[31m>>>>>>>>>>>copy systemd file<<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_pwd|${rabbitmq_appuser_pwd}|" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[31m>>>>>>>>>>>Load the service<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment