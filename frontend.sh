script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

echo -e "\e[31m>>>>>>>>>>>>>>>Install Nginx<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[31m>>>>>>>>>>>>>>>Copy Nginx Reverse Proxy file<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[31m>>>>>>>>>>>>>>>Remove default content from web server<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[31m>>>>>>>>>>>>>>>Download the frontend content<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[31m>>>>>>>>>>>>>>>Extract the frontend content<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[31m>>>>>>>>>>>>>>>Restart Nginx Service<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx