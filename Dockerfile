FROM mcr.microsoft.com/mssql/server:latest
LABEL maintainer="Isaac Martinez"


USER root

RUN apt-get update && apt-get install -y sudo && \
    usermod -a -G root,sudo mssql && \
    echo "mssql ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER mssql
# apt-get and system utilities
# install SQL Server drivers and tools
# dotnet core
RUN sudo ACCEPT_EULA=Y apt-get install -fy curl \
    apt-transport-https \
    debconf-utils \
    msodbcsql \
    mssql-tools \
    dotnet-runtime-2.2 \
    locales \
    libunwind8 \
    libicu55 \
    unzip

RUN sudo mkdir /opt/mssql-tools/bin/sqlpackage/ && \
    sudo locale-gen en_US.UTF-8 && sudo update-locale LANG=en_US.UTF-8

# # Link provided on this page:
# # https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download?view=sql-server-ver15
ADD https://download.microsoft.com/download/d/e/b/deb7b081-a3dc-47ea-8f2a-48cd8e486036/sqlpackage-linux-x64-en-US-15.0.4630.1.zip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip
RUN sudo unzip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip -d /opt/mssql-tools/bin/sqlpackage/

RUN sudo chmod a+x /opt/mssql-tools/bin/sqlpackage/sqlpackage
ENV sqlpackage=/opt/mssql-tools/bin/sqlpackage/sqlpackage
ENV PATH=$PATH:/opt/mssql-tools/bin:/opt/mssql-tools/bin/sqlpackage:/opt/mssql/bin

VOLUME /devvol
WORKDIR /devvol