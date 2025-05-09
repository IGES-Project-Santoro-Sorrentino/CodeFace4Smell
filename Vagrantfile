# -*- mode: ruby -*-
# vi: set ft=ruby :

# Copyright Roger Meier <roger@bufferoverflow.ch>
# SPDX-License-Identifier:	Apache-2.0 BSD-2-Clause GPL-2.0+ MIT WTFPL

$build = <<SCRIPT
cd /vagrant

integration-scripts/install_repositories.sh
integration-scripts/install_common.sh
integration-scripts/install_codeface_R.sh
integration-scripts/install_codeface_node.sh
integration-scripts/install_codeface_python.sh

integration-scripts/install_cppstats.sh

integration-scripts/setup_database.sh
SCRIPT

$checkVagrantFolder = <<SCRIPT
echo "Contenuto di /vagrant:"
ls -la /vagrant || echo "⚠️  /vagrant NON montata!"
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.provider "docker" do |d|
        d.build_dir = "."                    # usa il Dockerfile
        d.has_ssh = true
    end

    config.vm.boot_timeout = 60
    config.vm.communicator = "ssh"

    # Needed to connect via ssh
    config.vm.network :forwarded_port, guest: 22, host: 2222

    # Forward main web ui (8081) and testing (8100) ports
    config.vm.network :forwarded_port, guest: 8081, host: 8081
    config.vm.network :forwarded_port, guest: 8100, host: 8100

    config.ssh.username = "vagrant"

    config.vm.provision "fix-no-tty", type: "shell" do |s|
        s.privileged = false
        s.inline = "sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    end

    config.vm.provision "local-mirror", type: "shell" do |s|
        s.privileged = false
        s.inline = "sed -i 's|http://[a-z\.]*\.ubuntu\.com/ubuntu|mirror://mirrors\.ubuntu\.com/mirrors\.txt|' /etc/apt/sources.list"
    end

    config.vm.provision "build", type: "shell" do |s|
        s.privileged = false
        s.inline = $build
    end

    config.vm.provision "test", type: "shell" do |s|
        s.privileged = false
        s.inline = "cd /vagrant && integration-scripts/test_codeface.sh"
    end

    config.vm.provision "check-vagrant-folder", type: "shell" do |s|
        s.privileged = false
        s.inline = <<-SHELL
            echo "Contenuto di /vagrant:"
            ls -la /vagrant || echo "⚠️  /vagrant NON montata!"
        SHELL
    end

    config.vm.provision "shell", inline: <<-SHELL
        echo "✅ Container avviato e accessibile via SSH!"
    SHELL
end