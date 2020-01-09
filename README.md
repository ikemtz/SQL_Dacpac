# SQL Dacpac

Based on the latest SQL server docker image, this image has the tools necessary to deploy your DacPac files to your SQL docker containers.  This image is intended to be used temporarily as part of your build process.  Please review the example below.

## Example Usage

```
FROM ikemtz/sql_dacpac:latest as sql-temp
ENV SA_PASSWORD=YOUR_DESIRED_PASSWORD \
    ACCEPT_EULA=Y \
    NEW_DB_NAME=YOUR_NEW_DATABASE_NAME

COPY /$NEW_DB_NAME.dacpac /dacpac/db.dacpac
RUN /opt/mssql/bin/sqlservr & sleep 20 \
    && dotnet /opt/mssql-tools/bin/sqlpackage/sqlpackage.dll /Action:Publish /TargetServerName:localhost /TargetUser:SA /TargetPassword:$SA_PASSWORD /SourceFile:/dacpac/db.dacpac /TargetDatabaseName:$NEW_DB_NAME /p:BlockOnPossibleDataLoss=false \
    && sleep 20 \
    && pkill sqlservr && sleep 10 \
    && rm -rf /dacpac

FROM mcr.microsoft.com/mssql/server
LABEL author="@IkeMtz"
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=YOUR_DESIRED_PASSWORD
EXPOSE 1433
COPY --from=sql-temp /var/opt/mssql/data/*.ldf /var/opt/mssql/data/
COPY --from=sql-temp /var/opt/mssql/data/*.mdf /var/opt/mssql/data/
```