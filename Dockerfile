FROM --platform=linux/amd64 ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 

RUN apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    curl \
    gnupg2 \
    ca-certificates \
    nano \
    software-properties-common \
    && apt-get clean

RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update --fix-missing
RUN apt install -y --no-install-recommends g++-10

# Create user (like codeface)
RUN useradd -m -s /bin/bash codeface && \
    echo "codeface:codeface" | chpasswd && \
    mkdir -p /etc/sudoers.d && \
    echo "codeface ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/codeface && \
    chmod 0440 /etc/sudoers.d/codeface

# # # Set up SSH
RUN mkdir /var/run/sshd && \
    mkdir -p /home/codeface/.ssh && \
    curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub -o /home/codeface/.ssh/authorized_keys && \
    chown -R codeface:codeface /home/codeface/.ssh && \
    chmod 700 /home/codeface/.ssh && chmod 600 /home/codeface/.ssh/authorized_keys

# # Set working directory
WORKDIR /codeface

# # The integration scripts are copied before the rest of the codebase to take advantage of Docker's caching mechanism
COPY integration-scripts/ integration-scripts/
COPY rpackages/ rpackages/
COPY setup.py setup.py

RUN chmod +x integration-scripts/*.sh
RUN chmod +x rpackages/*.R

# # Install additional dependencies
RUN bash integration-scripts/install_repositories.sh
RUN bash integration-scripts/install_common.sh
RUN bash integration-scripts/install_codeface_R.sh

# # Install R files
RUN Rscript rpackages/install_base_packages.R
RUN Rscript rpackages/install_cran_packages.R
RUN Rscript rpackages/install_bioc_packages.R
RUN Rscript rpackages/install_github_packages.R

RUN bash integration-scripts/install_codeface_node.sh
RUN bash integration-scripts/install_codeface_python.sh
RUN bash integration-scripts/install_cppstats.sh
RUN bash integration-scripts/setup_mysql.sh

COPY . .

# Preparo codeface dopo eseguito il login
#RUN chmod +x start_server.sh
#RUN echo "bash start_server.sh" >> /home/.bashrc

# Expose ports
EXPOSE 22 8081 8100

CMD ["/usr/sbin/sshd", "-D"]
