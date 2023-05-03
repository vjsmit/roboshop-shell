script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_pwd=$1

if [-z "$mysql_pwd"]; then
  echo mysql pwd missing
  exit
fi

print_head "Install Maven"
yum install maven -y

print_head "Add app user"
useradd roboshop

print_head "setup an app directory"
rm -rf /app
mkdir /app

print_head "Download app code"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

print_head "Unzip app code"
unzip /tmp/shipping.zip

print_head "Download Maven dependencies"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

print_head "Copy service file"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

print_head "Install MYSQL Client"
yum install mysql -y

print_head "load schema to the DB"
mysql -h mysql-dev.smitdevops.online -uroot -p${mysql_pwd} < /app/schema/shipping.sql

print_head "Load the service"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping