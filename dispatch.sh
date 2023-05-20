script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_print_head "Install GoLang"
yum install golang -y

func_print_head "Add application User"
useradd ${app_user}

func_print_head "Create App dir"
rm -rf /app
mkdir /app

func_print_head "Download app code"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

func_print_head "Unzip app code"
unzip /tmp/dispatch.zip

func_print_head "Download dependencies & build SW"
go mod init dispatch
go get
go build

func_print_head "Copy systemD payment service"
cp ${script_path}/dispatch.service  /etc/systemd/system/dispatch.service

func_print_head "Restart the service"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch