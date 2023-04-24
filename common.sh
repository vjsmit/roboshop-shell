app_user=roboshop

print_head() {
echo -e "\e[31m>>>>>>>>>>>$1<<<<<<<<<<<<<<\e[0m"
}

schema_setup() {
echo -e "\e[31m>>>>>>>>>>>Copy MongoDB repo<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>>>>>>>>>Installing mongodb-client repo<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>>>>>>>>>Load Schema<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.smitdevops.online </app/schema/$(component).js

}

func_nodejs() {
  Setup NodeJS repo
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "NodeJS"
  yum install nodejs -y

  Add "app User"
  useradd ${app_user}

  print_head "an app directory"
  rm -rf /app
  mkdir /app
  echo -e "\e[31mOk\e[0m"

  print_head "the app code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip

  print_head "Download the dependencies"
  npm install

  print_head "SystemD User Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head "the service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}
  schema_setup
}