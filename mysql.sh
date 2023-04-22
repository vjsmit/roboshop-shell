echo -e "\e[31m>>>>>>>>>>DisableMySQL 8 Version<<<<<<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[31m>>>>>>>>>>Copy MySQL5.7 repo file<<<<<<<<<<<<<<\e[0m"
cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[31m>>>>>>>>>>Install MySQL Server<<<<<<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[31m>>>>>>>>>>Start MySQL Service<<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[31m>>>>>>>>>>Reset MYSQL pwd<<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
