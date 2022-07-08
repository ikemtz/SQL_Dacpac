FROM mcr.microsoft.com/mssql/server:2022-latest
LABEL maintainer="Isaac Martinez"
USER root

ENV ACCEPT_EULA=Y

RUN usermod -a -G root,sudo mssql && \
    echo "mssql ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg --purge packages-microsoft-prod && dpkg -i packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN apt-get update
RUN apt-get install -y apt-transport-https

RUN apt-get update
RUN apt-get install -y dotnet-sdk-6.0

# apt-get and system utilities
# install SQL Server drivers and tools
# dotnet core
RUN apt-get install -fy curl \
    debconf-utils \
    msodbcsql18 \
    mssql-tools18 \
    locales \
    libunwind8 \
    libicu66 \
    libssl1.1 \
    libssl-dev \
    unzip

RUN mkdir /opt/mssql-tools/bin/sqlpackage/ && \
    mkdir /var/opt/mssql/data && \
    mkdir /home/mssql && \
    mkdir /home/mssql/.dotnet && \
    locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# # Link provided on this page:
# # https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download?view=sql-server-ver16
ADD https://download.microsoft.com/download/f/0/9/f091c731-45be-48fa-ae84-bc28388e3ef8/sqlpackage-linux-x64-en-16.0.6161.0.zip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip
RUN unzip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip -d /opt/mssql-tools/bin/sqlpackage/

RUN chmod 777 -R /opt/mssql-tools/bin/sqlpackage  && \
    chmod 777 -R /var/opt/mssql/data  && \
    chmod 777 -R /home/mssql &&\
    chmod a+x opt/mssql-tools/bin/sqlpackage/sqlpackage
ENV sqlpackage=/opt/mssql-tools/bin/sqlpackage/sqlpackage
ENV PATH=$PATH:/opt/mssql-tools/bin:/opt/mssql-tools18/bin:opt/mssql-tools/bin/sqlpackage:/opt/mssql/bin

USER mssql
RUN echo $PATH >> ~/.bashrc
VOLUME /devvol