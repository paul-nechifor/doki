#!/bin/bash

packages=(
  expect
  httpd
  mysql
  mysql-devel
  mysql-server
  python-devel
  python-pip
)

main() {
  install_packages
  install_pip_packages
  configure_mysql
  setup_requirements
  setup_project
}

install_packages() {
  yum -y shell <<END
    update
    groupinstall "Development Tools"
    install ${packages[@]}
    run
END
}

install_pip_packages() {
  pip install virtualenv
}

configure_mysql() {
  chkconfig mysqld on
  service mysqld start
  mysql -u root --password="" -e 'create database if not exists db;'
}

setup_requirements() {
  cd /vagrant
  sudo su vagrant -c '
    virtualenv env
    . env/bin/activate
    pip install -r requirements/base.txt
  '
}

setup_project() {
  cd /vagrant/site
  . ../env/bin/activate
  expect -c '
    spawn ./manage.py syncdb
    expect "Would you like to create one now" { send "no\r" }
  '
  ./manage.py shell <<END
from django.contrib.auth.models import User
User.objects.create_superuser('admin', 'admin@example.com', 'admin')
END
}

main
