app_user=roboshop

print_head() {
echo -e "\e[31m>>>>>>>>>>>$1<<<<<<<<<<<<<\e[0m"
}

schema_setup() {
  if ["$schema_setup"== "mongo"]; then
      print_head "Copy MongoDB repo"
      cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

      print_head "Installing mongodb-client repo"
      yum install mongodb-org-shell -y

      print_head "Load Schema"
      mongo --host mongodb-dev.smitdevops.online </app/schema/$(component).js
  fi
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