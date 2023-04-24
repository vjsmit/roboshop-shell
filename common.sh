app_user=roboshop

func_nodejs() {
  echo -e "\e[31m>>>>>>>>>>>Setup NodeJS repo<<<<<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[31m>>>>>>>>>>>Install NodeJS<<<<<<<<<<<<<<\e[0m"
  yum install nodejs -y

  echo -e "\e[31m>>>>>>>>>>>Add app User<<<<<<<<<<<<<<\e[0m"
  useradd ${app_user}

  echo -e "\e[31m>>>>>>>>>>>setup an app directory<<<<<<<<<<<<<<\e[0m"
  rm -rf /app
  mkdir /app
  echo -e "\e[31mOk\e[0m"

  echo -e "\e[31m>>>>>>>>>>>Download the app code<<<<<<<<<<<<<<\e[0m"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip

  echo -e "\e[31m>>>>>>>>>>>download the dependencies<<<<<<<<<<<<<<\e[0m"
  npm install

  echo -e "\e[31m>>>>>>>>>>>Copy SystemD User Service<<<<<<<<<<<<<<\e[0m"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[31m>>>>>>>>>>>Load the service<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}
}