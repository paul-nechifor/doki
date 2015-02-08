Vagrant.configure('2') do |config|
  config.vm.box = 'centos-6.6'
  config.ssh.insert_key = false
  config.vm.network 'private_network', ip: '172.16.10.30'
  config.vm.provision 'shell', path: 'provision/provision.sh'
  config.vm.provider 'virtualbox' do |v|
    v.memory = 1024
    v.cpus = 1
  end
end
