script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh
mysql_pwd=$1

if [-z "$mysql_pwd"]; then
  echo mysql pwd missing
  exit
fi


echo -e "\e[31m>>>>>>>>>>DisableMySQL 8 Version"
dnf module disable mysql -y

echo -e "\e[31m>>>>>>>>>>Copy MySQL5.7 repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[31m>>>>>>>>>>Install MySQL Server"
yum install mysql-community-server -y

echo -e "\e[31m>>>>>>>>>>Start MySQL Service"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[31m>>>>>>>>>>Reset MYSQL pwd"
mysql_secure_installation --set-root-pass ${mysql_pwd}
