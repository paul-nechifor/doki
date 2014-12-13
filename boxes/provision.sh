#!/bin/bash

packages=(
  httpd
  mariadb
  python-pip
)

main() {
  install_packages
  install_pip_packages
  setup_requirements
}

install_packages() {
  #yum -y update
  rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
  yum -y install ${packages[@]}
}

install_pip_packages() {
  pip install virtualenv
}

setup_requirements() {
  cd /vagrant
  sudo -u vagrant
  virtualenv env
  . env/bin/activate
  pip install -r doki/requirements.txt
}

main
