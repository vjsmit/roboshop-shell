echo -e "\e[31m>>>>>>>>>>>Install Python 3.6<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[31m>>>>>>>>>>>Add app user<<<<<<<<<\e[0m"
useradd roboshop

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
cp /root/roboshop-shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[31m>>>>>>>>>>>Load the service<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment