FROM opensuse/leap:latest

# Refresh package list
RUN zypper refresh

# Install basic tools for Siemens STAR-CCM+ installation
RUN zypper install -y tar gzip wget hostname which

# Fetch STAR-CCM+ installer and run it
COPY wgetdrive.sh /tmp
RUN cd /tmp && \
    bash wgetdrive.sh '1TFxOn-8W-Kc5OlEbZjMqZ1v_IoccxVfM' starccm.tar.gz && \
    tar xf starccm.tar.gz && \
    ./starccm+_15.04.008/STAR-CCM+15.04.008_01_linux-x86_64-2.12_gnu7.1.sh -i silent -DPRODUCTEXCELLENCEPROGRAM=0 && \
    rm -rf starccm.tar.gz starccm+_15.04.008 wgetdrive.sh

# Install OpenSSH and configure it
# https://docs.docker.com/engine/examples/running_ssh_service/
RUN zypper install -y openssh
# Passwordless login is required by STAR-CCM+ ...
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

#ENV NOTVISIBLE="in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

# Create host keys
RUN ssh-keygen -A

EXPOSE 22

# Create user `boom` with no password
RUN useradd -m boom -p U6aMy0wojraho

# Set STAR-CCM+ network server for root and the user
USER boom
WORKDIR /home/boom
RUN echo 'CDLMD_LICENSE_FILE=1999@license.siemens.theprojectboom.org' > .flexlmrc

USER root
WORKDIR /root
RUN echo 'CDLMD_LICENSE_FILE=1999@license.siemens.theprojectboom.org' > .flexlmrc

# Run server
EXPOSE 40000-50000
CMD ["/usr/sbin/sshd", "-D"]
# CMD ["srun", "hostname". "|", "sort", "|", "uniq", ">", "~/machinefile"]
# CMD ["/opt/Siemens/15.04.008/STAR-CCM+15.04.008/star/bin/starccm+", "-server"]
