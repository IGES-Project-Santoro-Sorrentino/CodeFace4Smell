FROM --platform=linux/amd64 ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base packages and deps
RUN apt-get update 
RUN apt-get install -y --no-install-recommends \
    # openssh-server \
    sudo \
    curl \
    gnupg2 \
    ca-certificates && \
    apt-get clean

# Create user (like Vagrant)
RUN useradd -m -s /bin/bash vagrant && \
    echo "vagrant:vagrant" | chpasswd && \
    mkdir -p /etc/sudoers.d && \
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant && \
    chmod 0440 /etc/sudoers.d/vagrant

# Set up SSH
RUN mkdir /var/run/sshd && \
    mkdir -p /home/vagrant/.ssh && \
    curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && \
    chmod 700 /home/vagrant/.ssh && chmod 600 /home/vagrant/.ssh/authorized_keys

# # Install Node.js 20.x (fast install)
# RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
#     apt-get install -y nodejs

# Set working directory
WORKDIR /codeface
# The integration scripts are copied before the rest of the codebase to take advantage of Docker's caching mechanism
COPY integration-scripts/ integration-scripts/
COPY packages.R /codeface/packages.R

RUN chmod +x integration-scripts/*.sh

RUN bash integration-scripts/install_repositories.sh
RUN bash integration-scripts/install_common.sh
RUN bash integration-scripts/install_codeface_R.sh
RUN bash integration-scripts/install_codeface_node.sh
RUN bash integration-scripts/install_codeface_python.sh
RUN bash integration-scripts/install_cppstats.sh
RUN bash integration-scripts/setup_database.sh

COPY . .

# Expose ports
EXPOSE 22 8081 8100

CMD ["bash"]
