
[![Docker Pulls](https://img.shields.io/docker/pulls/ikemtz/sql_dacpac.svg)](https://hub.docker.com/repository/docker/ikemtz/sql_dacpac)

# SQL Dacpac

Based on the latest SQL server docker image, this image has the tools necessary to deploy your DacPac files to your SQL docker containers.  This image is intended to be used temporarily as part of your build process.  Please review the example below.

## Example Usage

```
FROM ikemtz/sql_dacpac:latest as sql-temp
ENV SA_PASSWORD=YOUR_DESIRED_PASSWORD \
    ACCEPT_EULA=Y \
    NEW_DB_NAME=YOUR_NEW_DATABASE_NAME

COPY /$NEW_DB_NAME.dacpac /dacpac/db.dacpac
RUN sqlservr & sleep 20 \
    && sqlpackage /Action:Publish /TargetServerName:localhost /TargetUser:SA /TargetPassword:$SA_PASSWORD /SourceFile:/dacpac/db.dacpac /TargetDatabaseName:$NEW_DB_NAME /p:BlockOnPossibleDataLoss=false \
    && sleep 20 \
    && pkill sqlservr && sleep 10 \
    && sudo rm -rf /dacpac

FROM mcr.microsoft.com/mssql/server:2019-latest
LABEL author="@IkeMtz"
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=YOUR_DESIRED_PASSWORD
EXPOSE 1433
COPY --from=sql-temp /var/opt/mssql/data/ /var/opt/mssql/data/

USER root
RUN chown -R mssql /var/opt/mssql/data
USER mssql
```

# SQL Dacpac

Based on the latest SQL server docker image, this image has the tools necessary to deploy your DacPac files to your SQL docker containers.  This image is intended to be used temporarily as part of your build process.  Please review the example below.

## Example Usage

```
FROM ikemtz/sql_dacpac:latest as sql-temp
ENV SA_PASSWORD=YOUR_DESIRED_PASSWORD \
    ACCEPT_EULA=Y \
    NEW_DB_NAME=YOUR_NEW_DATABASE_NAME

COPY /$NEW_DB_NAME.dacpac /dacpac/db.dacpac
RUN sqlservr & sleep 20 \
    && sqlpackage /Action:Publish /TargetServerName:localhost /TargetUser:SA /TargetPassword:$SA_PASSWORD /SourceFile:/dacpac/db.dacpac /TargetDatabaseName:$NEW_DB_NAME /p:BlockOnPossibleDataLoss=false \
    && sleep 20 \
    && pkill sqlservr && sleep 10 \
    && sudo rm -rf /dacpac

FROM mcr.microsoft.com/mssql/server:2019-latest
LABEL author="@IkeMtz"
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=YOUR_DESIRED_PASSWORD
EXPOSE 1433
COPY --from=sql-temp /var/opt/mssql/data/ /var/opt/mssql/data/

USER root
RUN chown -R mssql /var/opt/mssql/data
USER mssql
```
