FROM phusion/baseimage:0.9.15
MAINTAINER Andrea Brancaleoni "miwaxe@gmail.com"

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Setup multiarch because Skype is 32bit only
RUN dpkg --add-architecture i386

# Install Winswitch
RUN curl http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ trusty main" > /etc/apt/sources.list.d/winswitch.list
RUN apt-get update && apt-get install -y winswitch

# Create user "docker" and set the password to "docker"
RUN useradd -m -d /home/docker docker
RUN passwd -d docker
# RUN echo "docker:docker" | chpasswd

# Create OpenSSH privilege separation directory, enable X11Forwarding
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Prepare ssh config folder so we can upload SSH public key later
RUN mkdir /home/docker/.ssh
RUN chown -R docker:docker /home/docker
RUN chown -R docker:docker /home/docker/.ssh
RUN echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config

# Set locale (fix locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true
RUN echo "Europe/Rome" > /etc/timezone

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install Skype
ADD https://linux.dropbox.com/packages/ubuntu/dropbox_1.6.2_amd64.deb /tmp/dropbox.deb
RUN dpkg -i /tmp/dropbox.deb
RUN apt-get install -y python-gpgme
USER docker
WORKDIR /home/docker
ENV HOME /home/docker
RUN sleep 2 && printf 'y\n' | dropbox start -i

USER root
WORKDIR /
ENV HOME /root

RUN ln -s /home/docker/.dropbox-dist/dropboxd /usr/local/bin/dropboxd

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
