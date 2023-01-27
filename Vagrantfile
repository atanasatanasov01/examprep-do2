# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    
    config.ssh.insert_key = false
  
    config.vm.define "docker" do |docker|
      docker.vm.box = "shekeriev/centos-stream-9"
      docker.vm.hostname = "docker.do2.lab"
      docker.vm.network "private_network", ip: "192.168.99.100"
      docker.vm.network "forwarded_port", guest: 80, host: 8000
  
      docker.vm.provision "shell", inline: <<EOS
  echo "* Add EPEL repository ..."
  dnf install -y epel-release
  
  echo "* Install Python3 ..." 
  dnf install -y python3 python3-pip
  
  echo "* Install Python docker module ..."
  pip3 install docker
EOS
        docker.vm.provision "shell", inline: <<SCRIPT

echo "* Download Terraform" 
wget https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip -O /tmp/terraform.zip

echo "* Unzip Terraform"
unzip /tmp/terraform.zip

echo "* Move Terraform"
mv terraform /usr/local/bin

echo "* Remove the Terraform archive"
rm /tmp/terraform.zip
SCRIPT


      docker.vm.provision "ansible_local" do |ansible|
        ansible.become = true
        ansible.install_mode = :default
        ansible.playbook = "playbooks/docker.yml"
        ansible.galaxy_role_file = "playbooks/docker-req.yml"
        ansible.galaxy_roles_path = "/etc/ansible/roles"
        ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
      end
       
      docker.vm.provision "shell", inline: <<NETWORK
      echo "* Remove the network if it already exists.."
      docker network rm appnet || true
      echo "* Creating the app"
      docker network create appnet

NETWORK
    end
  end