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
  yum -y update
  yum -y groupinstall "Development Tools"
  rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
  yum -y install ${packages[@]}
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
  sudo -u vagrant
  virtualenv env
  . env/bin/activate
  pip install -r requirements/base.txt
}

setup_project() {
  cd /vagrant/src
  . ../env/bin/activate
  expect -c '
    spawn ./manage.py syncdb
    expect "Would you like to create one now" {
      send "yes\r"
      expect "Username" { send "admin\r"}
      expect "E-mail" { send "admin@example.com\r"}
      expect "Password" { send "admin\r"}
      expect "Password (again)" { send "admin\r"}
    }
  '
}

main
