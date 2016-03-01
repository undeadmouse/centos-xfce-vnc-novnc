FROM unigeocloud/centos-xfce:latest
MAINTAINER UniGeoCloud "sgi@unigeocloud.com"

ENV USER unigeo
ENV USER_HOME /home/unigeo
ENV DISPLAY :1
ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1280x720
ENV VNC_PW abcABC123
ENV VNC_PORT 5901
ENV NOVNC_PORT 80

RUN yum -y update;
RUN yum -y install tigervnc-server novnc firefox;

RUN useradd $USER -d $USER_HOME;

ADD user/.vnc $USER_HOME/.vnc
ADD user/.config $USER_HOME/.config
ADD user/Desktop $USER_HOME/Desktop

RUN chmod +x ${USER_HOME}/.vnc/xstartup ${USER_HOME}/Desktop/*.desktop;
RUN echo "${VNC_PW}" | /usr/bin/vncpasswd -f > ${USER_HOME}/.vnc/passwd 2>/dev/null;
RUN chown $USER:$USER -R $USER_HOME;

# Systemd #
RUN mkdir -p /etc/systemd/system/multi-user.target.wants/;
ADD vnc/vncserver@:1.service /etc/systemd/system/vncserver@:1.service
RUN ln -s /etc/systemd/system/vncserver@:1.service /etc/systemd/system/multi-user.target.wants/vncserver@:1.service;
ADD novnc/novnc.service /etc/systemd/system/novnc.service
RUN ln -s /etc/systemd/system/novnc.service /etc/systemd/system/multi-user.target.wants/novnc.service;
##########

ADD iptables /etc/sysconfig/iptables
ADD scripts/ /root/scripts
RUN chmod +x /root/scripts/vnc_novnc_startup.sh;

EXPOSE 5901
EXPOSE 80
