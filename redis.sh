echo -e "\e[31m>>>>>>>>>>>>Installing Redis repo file<<<<<<<<<<<<<<<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[31m>>>>>>>>>>>>Enable Redis 6.2<<<<<<<<<<<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[31m>>>>>>>>>>>>Install Redis<<<<<<<<<<<<<<<<\e[0m"
yum install redis -y

echo -e "\e[31m>>>>>>>>>>>>Update redis listen address<<<<<<<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf

echo -e "\e[31m>>>>>>>>>>>>Start & Enable Redis Service<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable redis
systemctl start redis