script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

func_print_head "Setup mongodb repo"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

func_print_head "Install MongoDB"
yum install mongodb-org -y &>>$log_file
func_status_check $?

func_status_check "Update mongodb listen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_status_check $?

func_print_head "Start MongoDB Service"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_status_check $?



