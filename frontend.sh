script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

print_head>Install Nginx<<<<<<<<"
yum install nginx -y

print_head>Copy Nginx Reverse Proxy file<<<<<<<<"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

print_head>Remove default content from web server<<<<<<<<"
rm -rf /usr/share/nginx/html/*

print_head>Download the frontend content<<<<<<<<"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

print_head>Extract the frontend content<<<<<<<<"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

print_head>Restart Nginx Service<<<<<<<<"
systemctl enable nginx
systemctl restart nginx