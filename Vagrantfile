# -*- mode: ruby -*-
# vi: set ft=ruby :

# Copyright Roger Meier <roger@bufferoverflow.ch>
# SPDX-License-Identifier:	Apache-2.0 BSD-2-Clause GPL-2.0+ MIT WTFPL

$build = <<SCRIPT
cd /vagrant

integration-scripts/install_repositories.sh
if [ $? -eq 0 ]; then
    echo "✅ Repositories installed successfully"
else
    echo "❌ Error installing repositories"
fi

integration-scripts/install_common.sh
if [ $? -eq 0 ]; then
    echo "✅ Common dependencies installed successfully"
else
    echo "❌ Error installing common dependencies"
fi

integration-scripts/install_codeface_R.sh
if [ $? -eq 0 ]; then
    echo "✅ Codeface R packages installed successfully"
else
    echo "❌ Error installing Codeface R packages"
fi

integration-scripts/install_codeface_node.sh
if [ $? -eq 0 ]; then
    echo "✅ Codeface Node.js dependencies installed successfully"
else
    echo "❌ Error installing Codeface Node.js dependencies"
fi

integration-scripts/install_codeface_python.sh
if [ $? -eq 0 ]; then
    echo "✅ Codeface Python dependencies installed successfully"
else
    echo "❌ Error installing Codeface Python dependencies"
fi

integration-scripts/install_cppstats.sh
if [ $? -eq 0 ]; then
    echo "✅ cppstats installed successfully"
else
    echo "❌ Error installing cppstats"
fi

integration-scripts/setup_database.sh
if [ $? -eq 0 ]; then
    echo "✅ Database setup completed successfully"
else
    echo "❌ Error setting up database"
fi
SCRIPT

Vagrant.configure("2") do |config|

    puts "Configuring Vagrant for Codeface..."
    config.vm.provider "docker" do |d|
        d.build_dir = "."
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

    # config.vm.provision "fix-no-tty", type: "shell" do |s|
    #     s.privileged = false
    #     s.inline = "sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    # end

    # config.vm.provision "local-mirror", type: "shell" do |s|
    #     s.privileged = false
    #     s.inline = "sed -i 's|http://[a-z\.]*\.ubuntu\.com/ubuntu|mirror://mirrors\.ubuntu\.com/mirrors\.txt|' /etc/apt/sources.list"
    # end

    config.vm.provision "build", type: "shell" do |s|
        s.privileged = false
        s.inline = $build
    end

    config.vm.provision "test", type: "shell" do |s|
        s.privileged = false
        s.inline = "cd /vagrant && integration-scripts/test_codeface.sh"
    end

    # config.vm.provision "check-vagrant-folder", type: "shell" do |s|
    #     s.privileged = false
    #     s.inline = <<-SHELL
    #         echo "Contenuto di /vagrant:"
    #         ls -la /vagrant || echo "⚠️  /vagrant NON montata!"
    #     SHELL
    # end

    config.vm.provision "shell", inline: <<-SHELL
        echo "✅ Container avviato e accessibile via SSH!"
    SHELL
end