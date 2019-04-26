FROM docker.io/library/fedora:28

ARG tfvers='0.11.13'

# Create working user
RUN useradd -d /home/demo -s /bin/bash demo

# Install dependencies
RUN dnf install -y \
        ansible \
        bash \
        less \
        openssh \
        openssh-clients \
        unzip \
        vim \
        wget \
        zip

# Setup bash environment
RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bashrc
RUN echo '[ ! -z "$TERM" -a -r /data/config.sh ] && source /data/config.sh' >> /etc/bashrc

# Install Terraform
RUN mkdir /tmp/tf
WORKDIR /tmp/tf
RUN wget https://releases.hashicorp.com/terraform/${tfvers}/terraform_${tfvers}_linux_amd64.zip
RUN unzip -qq terraform_${tfvers}_linux_amd64.zip
RUN mv terraform /usr/local/bin

# Setup Filesystem
RUN mkdir /app
RUN chown 1000:1000 /app
WORKDIR /app
RUN rm -rf /tmp/tf

# Install project
COPY resources/motd /etc/motd
RUN chmod 0544 /etc/motd
COPY resources/ssh_config /home/demo/.ssh/config
RUN chown demo /home/demo/.ssh/config; chmod 0600 /home/demo/.ssh/config
RUN mkdir /data.skel; chmod 755 /data.skel
COPY data.skel /data.skel
RUN chmod 644 /data.skel/*
COPY app /app

# Setup startup environment
USER demo
CMD /bin/bash
