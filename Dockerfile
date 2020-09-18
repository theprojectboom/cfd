FROM opensuse/leap:latest
RUN zypper install -y tar gzip wget hostname which

COPY wgetdrive.sh /tmp
RUN cd /tmp && \
    bash wgetdrive.sh '1TFxOn-8W-Kc5OlEbZjMqZ1v_IoccxVfM' starccm.tar.gz && \
    tar xf starccm.tar.gz && \
    ./starccm+_15.04.008/STAR-CCM+15.04.008_01_linux-x86_64-2.12_gnu7.1.sh -i silent -DPRODUCTEXCELLENCEPROGRAM=0 && \
    rm -rf starccm.tar.gz starccm+_15.04.008 wgetdrive.sh

WORKDIR /root
RUN echo 'CDLMD_LICENSE_FILE=1999@license.siemens.theprojectboom.org' > .flexlmrc
EXPOSE 47827

CMD ["/opt/Siemens/15.04.008/STAR-CCM+15.04.008/star/bin/starccm+", "-server"]
