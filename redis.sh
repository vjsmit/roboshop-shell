script=$(realpath $0)
script_path=$(dirname $script)
source ${script_path}/common.sh

print_head >Installing Redis repo file<<<"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

print_head >Enable Redis 6.2<<<"
dnf module enable redis:remi-6.2 -y

print_head >Install Redis<<"
yum install redis -y

print_head >Update redis listen address<<"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

print_head >Start & Enable Redis Service<<<"
systemctl enable redis
systemctl start redis