FROM mcr.microsoft.com/mssql/server:2022-latest
LABEL maintainer="@IkeMtz"
USER root

ENV ACCEPT_EULA=Y

RUN usermod -a -G root,sudo mssql \
    && echo "mssql ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && apt-get update \
    && apt-get install -y curl debconf-utils dotnet-sdk-9.0 msodbcsql18 mssql-tools18 unzip \
# apt-get and system utilities
# install SQL Server drivers and tools
# dotnet core
    && mkdir -p /opt/mssql-tools/ \
    && mkdir -p /var/opt/mssql/data/ \
    && mkdir -p /opt/mssql-tools/bin/sqlpackage/ \
    && mkdir -p /home/mssql/.dotnet \
    && dotnet tool install -g microsoft.sqlpackage \
    && apt-get clean

# # Link provided on this page:
# # https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download?view=sql-server-ver16
ADD https://download.microsoft.com/download/1/3/3/133c0627-7e5a-420a-9a76-3203e9a2884c/sqlpackage-linux-x64-en-162.3.566.1.zip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip
RUN unzip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip -d /opt/mssql-tools/bin/sqlpackage/

RUN chmod 777 -R /opt/mssql-tools/bin/sqlpackage \
    && chmod 777 -R /var/opt/mssql/data \
    && chmod 777 -R /home/mssql \
    && chmod a+x opt/mssql-tools/bin/sqlpackage/sqlpackage
ENV sqlpackage=/opt/mssql-tools/bin/sqlpackage/sqlpackage \
    PATH=$PATH:/opt/mssql-tools/bin:/opt/mssql-tools18/bin:opt/mssql-tools/bin/sqlpackage:/opt/mssql/bin
RUN sqlpackage /version
RUN dotnet --info
USER mssql
RUN echo "$PATH" >> ~/.bashrc
VOLUME /devvol