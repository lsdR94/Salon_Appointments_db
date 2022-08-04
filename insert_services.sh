#!/bin/bash

PSQL="psql -U freecodecamp --dbname salon -t -c"

TRUNCATE="$($PSQL "TRUNCATE services, appointments, customers")"
ALTER_SEQ_1="$($PSQL "ALTER SEQUENCE services_service_id_seq RESTART WITH 1")"

#Inserting data from csv
cat services.csv | while IFS=',' read NAME
do
  if [[ $NAME != 'name' ]]
    then 
      INSERT_SERVICE=$($PSQL "INSERT INTO services(name) VALUES('$NAME')")
  fi
done