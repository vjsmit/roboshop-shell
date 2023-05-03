script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_appuser_pwd=$1

if [-z "$rabbitmq_appuser_pwd"]; then
  echo Roboshop appuser pwd missing
  exit
fi


print_head "Configure YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

print_head "Install Erlang"
yum install erlang -y

print_head "Configure YUM Repos for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

print_head "Install RabbitMQ"
yum install rabbitmq-server -y

print_head "Start RabbitMQ Service"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

print_head "Change default username/pwd"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_pwd}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"