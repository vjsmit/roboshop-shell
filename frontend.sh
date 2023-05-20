script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_print_head "Install Nginx"
yum install nginx -y &>>$log_file
func_status_check $?

func_print_head "Copy Nginx Reverse Proxy file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_status_check $?

func_print_head "Remove default content from web server"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check $?

func_print_head "Download the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?

func_print_head "Extract the frontend content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?

func_print_head "Start Nginx Service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_status_check $?



