echo -e "\e[31m>>>>>>>>Install GoLang<<<<<<<<<<<<<\e[0m"
yum install golang -y

echo -e "\e[31m>>>>>>>>Install GoLang<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[31m>>>>>>>>Create App dir<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>Download app code<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

echo -e "\e[31m>>>>>>>>Unzip app code<<<<<<<<<<<<<\e[0m"
unzip /tmp/dispatch.zip

echo -e "\e[31m>>>>>>>>Download dependencies & build SW<<<<<<<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[31m>>>>>>>>Copy systemD payment service<<<<<<<<<<<<<\e[0m"
cp /root/roboshop-shell/dispatch.service  /etc/systemd/system/dispatch.service

echo -e "\e[31m>>>>>>>>Restart the service<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch