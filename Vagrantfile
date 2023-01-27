# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

    config.ssh.insert_key = false

    config.vm.define "docker" do |docker|
        docker.vm.box = "merev/centos-stream-9"
        docker.vm.hostname = "docker.do2.lab"
        docker.vm.network "private_network", ip: "192.168.99.100"
        docker.vm.provision "shell", inline: <<EOS
    echo "* Add EPEL repository..."
    dnf install -y epel-release

    echo "Install Python3 ..."
    dnf install -y python3 python3-pip

    echo "* Install Python docker module ..."
    pip3 install docker
EOS

        docker.vm.provision "ansible_local" do |ansible|
            ansible.become = true
            ansible.install_mode = :default
            ansible.playbook = "playbooks/docker.yml"
            ansible.galaxy_role_file = "playbooks/docdker-req.yml"
            ansible.galaxy_roles_path = "/etc/ansible/roles"
            ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} ==roles-path%{roles_path} --force"
        end
    end
end
