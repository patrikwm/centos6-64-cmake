FROM centos:6.9
MAINTAINER "Patrik Martin" <patrik.martin@mideye.com>


RUN yum -y install epel-release && \
    yum -y groupinstall 'Development tools' && \
    yum -y install \
           rpm-build \
           git \
           gcc \
           gtest \
           gtest-devel \
           cmake \
           openssl-devel \
           libxml2-devel \
           mysql-devel \
           mysql-connector-odbc \
           unixODBC-devel \
           openldap-devel \
    yum clean all

RUN useradd builder -u 1000 -m -G users,wheel && \
    echo "builder ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "# macros"                      >  /home/builder/.rpmmacros && \
    echo "%_topdir    /home/builder/rpm" >> /home/builder/.rpmmacros && \
    echo "%_sourcedir %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_builddir  %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_specdir   %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_rpmdir    %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_srcrpmdir %{_topdir}"        >> /home/builder/.rpmmacros && \
    mkdir /home/builder/rpm && \
    chown -R builder /home/builder
USER builder
WORKDIR "/home/builder"
ENV FLAVOR=rpmbuild OS=centos DIST=el6
CMD /bin/bash
