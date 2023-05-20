script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
rabbitmq_appuser_pwd=$1

if [-z "$rabbitmq_appuser_pwd"]; then
  echo rabbitmq appuser pwd missing
  exit
fi

component=payment
func_python

