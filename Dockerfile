FROM --platform=linux/amd64 ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CC=/usr/bin/gcc
ENV APPLY_LP2002043_UBUNTU_CFLAGS_WORKAROUND=1

# 1. Installa curl, openssh-server e sudo (Alcune di queste librerie sono necessarie per mac m1, controllare se sono necessarie anche per altre distro)
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    git \
    python \
    python-dev \
    libmysqlclient-dev \
    gcc-multilib g++-multilib 

# 1.1 Installa pip per python2
RUN curl -fsSL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# 1.2 Installa nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

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

# 6. Install npm packages
WORKDIR /vagrant/id_service
RUN npm install

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
