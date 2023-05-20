script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_print_head "Installing Redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_status_check $?

func_print_head "Enable Redis 6.2"
dnf module enable redis:remi-6.2 -y &>>$log_file
func_status_check $?

func_print_head "Install Redis"
yum install redis -y &>>$log_file
func_status_check $?

func_print_head "Update redis listen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
func_status_check $?

func_print_head "Start Redis Service"
systemctl enable redis &>>$log_file
systemctl start redis &>>$log_file
func_status_check $?

