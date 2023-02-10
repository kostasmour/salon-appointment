#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "$($PSQL "select * from services")" |sed 's/|/) /' 
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ [1-3] ]] 
  then
  MAIN_MENU "I could not find that service. What would you like today?"
  else 
  SERVICE
  fi
}

SERVICE() {
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
PHONE_CHECKER=$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE'")

if [[ -z $PHONE_CHECKER ]]
then

echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME

INSERT_CUSTOMER=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone = '$CUSTOMER_PHONE' ")

echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME

INSERT_APPOINTMENT=$($PSQL "insert into appointments(time,service_id,customer_id) values('$SERVICE_TIME',$SERVICE_ID_SELECTED,$CUSTOMER_ID)")
echo I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME.

else
CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone = '$CUSTOMER_PHONE' ")

echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME 

INSERT_APPOINTMENT=$($PSQL "insert into appointments(time,service_id,customer_id) values('$SERVICE_TIME',$SERVICE_ID_SELECTED,$CUSTOMER_ID)")

CUSTOMER_name=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")

echo I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_name.
fi
}

MAIN_MENU "Welcome to My Salon, how can I help you?"
