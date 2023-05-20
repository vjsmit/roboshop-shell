script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_pwd=$1

if [-z "$mysql_pwd"]; then
  echo mysql pwd missing
  exit
fi

component="shipping"
schema_setup=mysql
func_java