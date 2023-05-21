script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_pwd=$1

if [-z "$mysql_pwd"]; then
  echo mysql pwd missing
  exit
fi

func_print_head "Disable MySQL 8 Version"
dnf module disable mysql -y &>>$log_file
func_status_check $?

func_print_head "Copy MySQL5.7 repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

func_print_head "Install MySQL Server"
yum install mysql-community-server -y &>>$log_file
func_status_check $?

func_print_head "Start MySQL Service"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_status_check $?

func_print_head "Reset MYSQL pwd"
mysql_secure_installation --set-root-pass ${mysql_pwd} &>>$log_file
func_status_check $?
