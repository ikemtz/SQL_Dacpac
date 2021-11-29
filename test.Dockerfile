FROM ikemtz/sql_dacpac:beta as sql-temp
ENV SA_PASSWORD=SqlDockerRocks123! \
    ACCEPT_EULA=Y \
    NEW_DB_NAME=YOUR_NEW_DATABASE_NAME
COPY *.dacpac /dacpac/
RUN /opt/mssql/bin/sqlservr & sleep 20 \
    && sqlpackage /Action:Publish /TargetServerName:localhost /TargetUser:sa /TargetPassword:$SA_PASSWORD /SourceFile:/dacpac/test.dacpac /TargetDatabaseName:$NEW_DB_NAME /p:BlockOnPossibleDataLoss=false \
    && sleep 20 \
    && pkill sqlservr && sleep 10

FROM mcr.microsoft.com/mssql/server
LABEL author="@IkeMtz"
ENV SA_PASSWORD=SqlDockerRocks123! \
    ACCEPT_EULA=Y \
    NEW_DB_NAME=YOUR_NEW_DATABASE_NAME
EXPOSE 1433

COPY --from=sql-temp /var/opt/mssql/data/$NEW_DB_NAME*.ldf /var/opt/mssql/data/
COPY --from=sql-temp /var/opt/mssql/data/$NEW_DB_NAME*.mdf /var/opt/mssql/data/

USER root
RUN chown -R mssql /var/opt/mssql/data
USER mssql