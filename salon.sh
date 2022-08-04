#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"

#Service menu
SERVICE_MENU() {
  #available services
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME" 
  done

  #Ask for service to select
  read SERVICE_ID_SELECTED

  #Check availability of the selected service
  SERVICE_AVAILABILITY="$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")"
  
  if [[ -z $SERVICE_AVAILABILITY ]]
  then 
    echo -e "\nI could not find that service. What would you like today?"
    SERVICE_MENU
  else
    echo -e "\nInsert phone number"
    read CUSTOMER_PHONE

    #If phone number is not in the database, ask name and service time
    CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")"

    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      echo -e "\nWhat time would you like your cut, Fabio?"
      read SERVICE_TIME

      #Insert customer data
      CUSTOMER_DATA=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

      #Create an appoinment
      CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME' and phone = '$CUSTOMER_PHONE'")"
      CREATE_APPOINMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

      #Output
      SERVICE_NAME="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")"
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi
}

SERVICE_MENU