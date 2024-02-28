FROM mcr.microsoft.com/mssql/server:2022-latest
LABEL maintainer="Isaac Martinez"
USER root

ENV ACCEPT_EULA=Y

RUN usermod -a -G root,sudo mssql \
    && echo "mssql ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && apt-get update \
    && apt-get install -y dotnet-sdk-7.0 curl \

# apt-get and system utilities
# install SQL Server drivers and tools
# dotnet core
        debconf-utils \
        msodbcsql18 \
        mssql-tools18 \
        locales \
        libunwind8 \
        libssl-dev \
        unzip \
    && mkdir /opt/mssql-tools/bin/sqlpackage/ \
    && mkdir /var/opt/mssql/data \
    && mkdir /home/mssql \
    && mkdir /home/mssql/.dotnet \
    && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 \
    && apt-get clean \
# RUN  dotnet tool install -g microsoft.sqlpackage
# # Link provided on this page:
# # https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download?view=sql-server-ver16
ADD https://download.microsoft.com/download/d/0/5/d05fd9de-4d32-48d4-9a6d-f089b0288eb6/sqlpackage-linux-x64-en-162.2.111.2.zip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip
RUN unzip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip -d /opt/mssql-tools/bin/sqlpackage/

RUN chmod 777 -R /opt/mssql-tools/bin/sqlpackage \
    && chmod 777 -R /var/opt/mssql/data \
    && chmod 777 -R /home/mssql \
    && chmod a+x opt/mssql-tools/bin/sqlpackage/sqlpackage
ENV sqlpackage=/opt/mssql-tools/bin/sqlpackage/sqlpackage \
    PATH=$PATH:/opt/mssql-tools/bin:/opt/mssql-tools18/bin:opt/mssql-tools/bin/sqlpackage:/opt/mssql/bin
RUN sqlpackage /version
RUN dotnet /version
USER mssql
RUN echo "$PATH" >> ~/.bashrc
VOLUME /devvol