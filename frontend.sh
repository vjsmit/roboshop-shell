echo -e "\e[34m>>>>>>>>>>>>>>>Install Nginx<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[34m>>>>>>>>>>>>>>>Copy Nginx Reverse Proxy file<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[34m>>>>>>>>>>>>>>>Remove default content from web server<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[34m>>>>>>>>>>>>>>>Download the frontend content<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[34m>>>>>>>>>>>>>>>Extract the frontend content<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[34m>>>>>>>>>>>>>>>Restart Nginx Service<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx