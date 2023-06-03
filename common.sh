app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
#rm -f $log_file

func_print_head() {
echo -e "\e[31m>>>>>>>>>>>$1<<<<<<<<<<<<<\e[0m"
echo -e "\e[31m>>>>>>>>>>>$1<<<<<<<<<<<<<\e[0m" &>>$log_file
}

func_status_check(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Refer the log file /tmp/roboshop.log for more info"
    exit 1
  fi
}

func_schema_setup() {
  if ["$schema_setup"== "mongo"]; then
      func_print_head "Copy MongoDB repo"
      cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
      func_status_check $?

      func_print_head "Installing mongodb-client repo"
      yum install mongodb-org-shell -y &>>$log_file
      func_status_check $?

      func_print_head "Load Schema"
      mongo --host mongodb-dev.smitdevops.online </app/schema/$(component).js &>>$log_file
      func_status_check $?
  fi
  if [ "$schema_setup"== "mysql" ]; then
      func_print_head "Install MYSQL Client"
      yum install mysql -y &>>$log_file
      func_status_check $?

      func_print_head "load schema to the DB"
      mysql -h mysql-dev.smitdevops.online -uroot -p${mysql_pwd} < /app/schema/${component}.sql &>>$log_file
      func_status_check $?
  fi
 }

func_app_prereq() {

  func_print_head "Add app user"
  id ${app_user} &>>$log_file
  if [ id $? -ne 0 ]; then
    useradd ${app_user} &>>$log_file
  fi
  func_status_check $?

  func_print_head "setup an app directory"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  func_status_check $?

  func_print_head "Download the app code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  func_status_check $?
  cd /app

  func_print_head "Unzip app code"
  unzip /tmp/${component}.zip &>>$log_file
  func_status_check $?
}

func_systemd_setup(){

func_print_head "SystemD User Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_status_check $?

  func_print_head "Load the service"
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl start ${component} &>>$log_file
  func_status_check $?
 }

func_nodejs() {
  func_print_head "Setup NodeJS repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_status_check $?

  func_print_head "NodeJS"
  yum install nodejs -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_print_head "Download the dependencies"
  npm install &>>$log_file
  func_status_check $?

  func_schema_setup
  func_systemd_setup
}

func_java() {
  func_print_head "Install Maven"
  yum install maven -y &>>/tmp/roboshop.log &>>$log_file
  func_status_check $?

  func_app_prereq

  func_print_head "Download Maven dependencies"
  mvn clean package &>>$log_file
  func_status_check $?

  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_status_check $?

  func_schema_setup
  func_systemd_setup
}


func_python(){

  func_print_head "Install Python 3.6"
  yum install python36 gcc python3-devel -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_print_head "Download python dependencies"
  pip3.6 install -r requirements.txt &>>$log_file
  func_status_check $?

  func_print_head "Update passwords in System service file"
  sed -i -e "s|rabbitmq_appuser_pwd|${rabbitmq_appuser_pwd}|" ${script_path}/${component}.service &>>$log_file
  func_status_check $?

  func_systemd_setup
}

func_golang() {
  func_print_head "Install GoLang"
  yum install golang -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_print_head "Download dependencies & build software"
  go mod init dispatch &>>$log_file
  func_status_check $?

  go get &>>$log_file
  func_status_check $?

  go build &>>$log_file
  func_status_check $?

  func_systemd_setup
}