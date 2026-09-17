FROM mcr.microsoft.com/mssql/server:latest
LABEL maintainer="@IkeMtz"
USER root

ENV ACCEPT_EULA=Y

RUN usermod -a -G root,sudo mssql \
    && echo "mssql ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && apt-get update \
    && apt-get install -y curl debconf-utils dotnet-sdk-10.0 msodbcsql18 mssql-tools18 unzip \
# apt-get and system utilities
# install SQL Server drivers and tools
# dotnet core
    && mkdir -p /var/opt/mssql/data/ \
    && mkdir -p /home/mssql/.dotnet \
    && dotnet tool install -g microsoft.sqlpackage --allow-roll-forward \
    && apt-get clean

ENV PATH=$PATH:/opt/mssql-tools18/bin:/opt/mssql/bin:/root/.dotnet/tools

RUN chmod 777 -R /var/opt/mssql/data \
    && chmod 777 -R /root/.dotnet/tools \
    && chmod 777 -R /home/mssql \
    && dotnet --info

VOLUME /devvol