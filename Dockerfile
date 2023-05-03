FROM ubuntu:20.04
ENV container docker

# Install systemd and other necessary packages
RUN apt-get update && \
    apt-get install -y systemd systemd-sysv dbus && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Remove some unnecessary services to reduce startup time
RUN systemctl mask \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount \
    systemd-remount-fs.service \
    sys-kernel-config.mount \
    sys-kernel-debug.mount \
    display-manager.service \
    getty@.service \
    systemd-logind.service \
    systemd-journald-audit.socket \
    systemd-journald-dev-log.socket \
    systemd-journald.socket \
    systemd-vconsole-setup.service && \
    systemctl set-default multi-user.target

# Add a custom systemd unit file
#COPY myservice.service /etc/systemd/system/myservice.service

# Enable and start the service
#RUN systemctl enable myservice.service

#install packages
RUN apt-get update
RUN apt-get install -y openssh-server
RUN apt-get install -y iproute2
RUN apt-get install -y sudo
RUN apt-get install -y htop
RUN apt-get install -y nano
RUN apt-get install -y rsyslog

#expose ports
EXPOSE 22
EXPOSE 80
EXPOSE 25
EXPOSE 443

#add public key
RUN mkdir /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys

#add run environment for sshd
RUN mkdir /var/run/sshd

#start rsyslog and ssh
#RUN systemctl start rsyslog
#RUN systemctl start sshd

CMD ["/sbin/init"]
