FROM --platform=linux/amd64 ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CC=/usr/bin/gcc
ENV APPLY_LP2002043_UBUNTU_CFLAGS_WORKAROUND=1

# 1. Installazione pacchetti di base
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    git \
    python \
    python-dev \
    libmysqlclient-dev \
    gcc-multilib \
    g++-multilib \
    mysql-server \
    net-tools \
    && apt-get clean

# 2. Installa pip per Python 2.7
RUN curl -fsSL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# 3. Installa librerie Python
RUN pip install "mock<3"

# 4. Installa Node.js e npm
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# 5. Crea utente vagrant con sudo
RUN useradd -m -s /bin/bash vagrant && echo "vagrant:vagrant" | chpasswd && adduser vagrant sudo

# 6. Setup SSH
RUN mkdir /var/run/sshd

# 7. Aggiungi chiave pubblica Vagrant per login SSH
RUN mkdir -p /home/vagrant/.ssh
RUN curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh && chmod 700 /home/vagrant/.ssh && chmod 600 /home/vagrant/.ssh/authorized_keys

# 8. Configura SSH
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 9. Install npm packages
WORKDIR /vagrant/id_service
RUN npm install

# 10. Run mysql server

COPY ./datamodel/codeface_schema.sql /codeface_schema.sql
COPY setup_mysql.sh /setup_mysql.sh
COPY start_server.sh /start_server.sh

RUN chmod +x /setup_mysql.sh && /setup_mysql.sh

# 11. Preparo codeface dopo eseguito il login
RUN chown vagrant:vagrant /start_server.sh && chmod +x //start_server.sh
RUN echo "bash /start_server.sh" >> /home/vagrant/.bashrc

EXPOSE 22

# CMD ["/usr/sbin/sshd", "-D"]
CMD bash -c "service mysql start && exec /usr/sbin/sshd -D"

