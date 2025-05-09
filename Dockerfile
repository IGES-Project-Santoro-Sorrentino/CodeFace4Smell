FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Installa curl, openssh-server e sudo
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    python \
    python-pip \

# 2. Crea utente vagrant con sudo
RUN useradd -m -s /bin/bash vagrant && echo "vagrant:vagrant" | chpasswd && adduser vagrant sudo

# 3. Setup SSH
RUN mkdir /var/run/sshd

# 4. Aggiungi chiave pubblica Vagrant per login SSH
RUN mkdir -p /home/vagrant/.ssh
RUN curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh && chmod 700 /home/vagrant/.ssh && chmod 600 /home/vagrant/.ssh/authorized_keys

# 5. Configura SSH
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
