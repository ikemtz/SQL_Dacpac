FROM mcr.microsoft.com/mssql/server:latest

LABEL maintainer="Isaac Martinez"

# apt-get and system utilities
RUN apt-get update && apt-get install -y \
	curl apt-transport-https debconf-utils \
    && rm -rf /var/lib/apt/lists/*


# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# install dotnet core
RUN apt-get -y install dotnet-runtime-2.2

RUN apt-get -y install locales
RUN apt-get install libunwind8
RUN apt-get install libicu55
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN apt-get -y install unzip
RUN apt-get -y install libunwind-dev

RUN mkdir /opt/mssql-tools/bin/sqlpackage/
ENV PATH="/opt/mssql-tools/bin:/opt/mssql-tools/bin/sqlpackage/:${PATH}"
# Link provided on this page:
# https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download?view=sql-server-2017
ADD https://download.microsoft.com/download/d/e/b/deb7b081-a3dc-47ea-8f2a-48cd8e486036/sqlpackage-linux-x64-en-US-15.0.4630.1.zip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip

RUN unzip /opt/mssql-tools/bin/sqlpackage/sqlpackage.zip -d /opt/mssql-tools/bin/sqlpackage/
VOLUME /devvol
WORKDIR /devvol