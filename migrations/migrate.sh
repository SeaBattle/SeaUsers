#!/bin/sh
USERNAME="postgres"
DATABASE="seaserver"
CLASSPATH=postgresql-9.4.1212.jar
PASSWORD="sea_wind_arrr!"

if [[ -z "$DB_URL" ]]
then
    URL=$DB_URL
else
    URL="jdbc:postgresql://localhost/"$DATABASE
fi

case ${1} in
   "update")
        liquibase --driver=org.postgresql.Driver \
        --url=$URL --changeLogFile=changelog.xml \
        --classpath=$CLASSPATH \
        --username=$USERNAME --password=$PASSWORD update
   ;;
   "roll")
        liquibase --driver=org.postgresql.Driver \
        --url=$URL \
        --classpath=$CLASSPATH \
        --username=$USERNAME --password=$PASSWORD --changeLogFile=changelog.xml \
        rollback ${2}
   ;;
   "tag")
        liquibase --driver=org.postgresql.Driver \
         --url=$URL \
         --classpath=$CLASSPATH \
         --username=$USERNAME --password=$PASSWORD --changeLogFile=changelog.xml tag ${2}
   ;;
   *) echo "`basename ${0}`:usage: [update] | [roll name] | [tag name]"
      exit 1
      ;;
esac