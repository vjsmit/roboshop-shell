echo -e "\e[34m>>>>>>>>>>>>>>>Install Nginx<<<<<<<<<<<<<<<<<<<<<<"
yum install nginx -y

echo -e "\e[34m>>>>>>>>>>>>>>>Copy Nginx Reverse Proxy file<<<<<<<<<<<<<<<<<<<<<<"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[34m>>>>>>>>>>>>>>>Remove the default content that web server is serving<<<<<<<<<<<<<<<<<<<<<<"
rm -rf /usr/share/nginx/html/*

echo -e "\e[34m>>>>>>>>>>>>>>>Download the frontend content<<<<<<<<<<<<<<<<<<<<<<"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[34m>>>>>>>>>>>>>>>Extract the frontend content<<<<<<<<<<<<<<<<<<<<<<"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[34m>>>>>>>>>>>>>>>Restart Nginx Service<<<<<<<<<<<<<<<<<<<<<<"
systemctl enable nginx
systemctl restart nginx