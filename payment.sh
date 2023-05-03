script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_appuser_pwd=$1

if [-z "$rabbitmq_appuser_pwd"]; then
  echo rabbitmq appuser pwd missing
  exit
fi

print_head "Install Python 3.6"
yum install python36 gcc python3-devel -y

print_head "Add app user"
useradd ${app_user}

print_head "Add app directory"
rm -rf /app
mkdir /app

print_head "Download the app code"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

print_head "unzip the app code"
unzip /tmp/payment.zip

print_head "Download dependencies"
pip3.6 install -r requirements.txt

print_head "Copy systemd file"
sed -i -e "s|rabbitmq_appuser_pwd|${rabbitmq_appuser_pwd}|" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

print_head "Load the Service"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment