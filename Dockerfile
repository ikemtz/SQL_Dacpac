FROM mcr.microsoft.com/mssql/server:2019-latest
LABEL maintainer="Isaac Martinez"
USER root

RUN usermod -a -G root,sudo mssql && \
    echo "mssql ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg --purge packages-microsoft-prod && dpkg -i packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN apt-get update
RUN apt-get install -y apt-transport-https

RUN apt-get update
RUN apt-get install -y dotnet-sdk-5.0
RUN apt-get install -y dotnet-sdk-6.0

# apt-get and system utilities
# install SQL Server drivers and tools
# dotnet core
RUN apt-get install -fy curl \
    debconf-utils \
    msodbcsql17 \
    mssql-tools \
    locales \
    libunwind8 \
    libicu66 \
    libssl1.1 \
    libssl-dev \
    unzip

RUN mkdir /opt/mssql-tools/bin/sqlpackage/ && \
    mkdir /var/opt/mssql/data && \
    locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# # Link provided on this page:
# # https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download?view=sql-server-ver15
ADD https://download.microsoft.com/download/3/b/5/3b56a8c9-6c4d-4bf7-b503-23ecc1499929/sqlpackage-linux-x64-en-US-15.0.5282.3.zip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip
RUN unzip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip -d /opt/mssql-tools/bin/sqlpackage/

RUN chmod 777 -R /opt/mssql-tools/bin/sqlpackage  && \
    chmod 777 -R /var/opt/mssql/data
ENV sqlpackage=/opt/mssql-tools/bin/sqlpackage/sqlpackage
ENV PATH=$PATH:/opt/mssql-tools/bin:/opt/mssql-tools/bin/sqlpackage:/opt/mssql/bin

USER mssql
VOLUME /devvol
WORKDIR /devvol