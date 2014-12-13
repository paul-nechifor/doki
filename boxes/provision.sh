#!/bin/bash

packages=(
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
  mysql -u root --password="" -e 'create database doki;'
}

setup_requirements() {
  cd /vagrant
  sudo -u vagrant
  virtualenv env
  . env/bin/activate
  pip install -r doki/requirements.txt
}

main
