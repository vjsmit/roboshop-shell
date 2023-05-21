script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_appuser_pwd=$1

if [-z "$rabbitmq_appuser_pwd"]; then
  echo Roboshop appuser pwd missing
  exit 1
fi

func_print_head "Configure Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_status_check $?

func_print_head "Configure  RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_status_check $?

func_print_head "Install Erlang"
yum install erlang -y &>>$log_file
func_status_check $?

func_print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>$log_file
func_status_check $?

func_print_head "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
func_status_check $?

func_print_head "Add Application User in RabbtiMQ"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_pwd} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_status_check $?