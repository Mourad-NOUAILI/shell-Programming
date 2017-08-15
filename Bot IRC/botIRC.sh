#!/bin/bash

connexion () {
  echo "Trying connection to $server on port $port ..."
  exec 5<>/dev/tcp/$server/$port

  echo -ne "USER formationBot formationBot_ no-name :ddsdsdsdsds\r\n" >&5
  echo -ne "NICK formationBot\r\n" >&5
  echo -ne "JOIN #formationLinux\r\n" >&5
}

speakInPublic () {
  echo -ne "PRIVMSG #formationLinux :$1 \r\n" >&5
}

getAndManageServerResponse () {
  whoFlag=0
  while true
  do
    response=$(head -n 1 <&5)
    echo $response
    
    #Getting ping message ane sending pong message
    if [[ "$response" =~ ^PING.*$ ]]
    then
      echo "PONG ${response:5}"
      speakInPublic "PONG ${response:5}"
    fi

    if [ $whoFlag -eq 1 ]
    then
      whoFlag=0
      if [[ "$response" =~ ^.*(([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}).*$ ]]
      then
        speakInPublic "IP = ${BASH_REMATCH[1]}"
      fi
    fi

    if [[ "$response" =~ ^:(.*)!~(.*)JOIN(.*)$ ]]
    then
      if [ ${BASH_REMATCH[1]} != "formationBot" ]
      then
        speakInPublic "PRIVMSG #formationLinux :Bonjour ${BASH_REMATCH[1]}"
      fi
    fi
    
    response=${response%$'\r'}
    #echo $response | sed -i 's/\r$//g'
    #echo "$response" | tr '\n' ''
    if [[ $response =~ ^:(.*)!~.*PRIVMSG.*:(.*)$ ]]
    then
      nick=${BASH_REMATCH[1]}
      msg=${BASH_REMATCH[2]}
      if [ $nick != "formationBot" ]
      then
        if [[ $msg =~ ^.*windows.*$ ]]
        then
          speakInPublic "$nick, On dit pas 'Windows' ici, on dit 'Windaube' ;)"
	fi

	if [[ $msg =~ ^!who[[:space:]]+([^[:space:]]*)$ ]]
	then
          if [ ${BASH_REMATCH[1]} = "formationBot" ]
          then
            speakInPublic "**********************************************************************************************************"
            speakInPublic "formationBot 2016-2017 - Email :formationBot@gmail.com"
            speakInPublic "Description: IRC Bot simple. Dans le cadre d'une formation Linux pour les enseignants."
            speakInPublic "**********************************************************************************************************"
          else
            whoFlag=1
            echo -ne "WHOIS ${BASH_REMATCH[1]}\r\n" >&5
          fi
        fi
      fi
    fi
  done

}

usage() {
  cat <<EOF
  Usage: $0 options
  Options:
        -s   --server         L'adresse de serveur IRC.
        -p   --port           Le port de serveur IRC.
        -h   --help           Montre ce contenu.
  Comment:
        $0 [-i|--slis -u|--user usermane -w|--pass password] --server|-s server-irc --port|-p port-num
        $0 -h|--help

EOF
}

#---------------Main program-------------------------
for arg in "$@"; do
  shift
  case "$arg" in
    "--server") set -- "$@" "-s" ;;
    "--port")   set -- "$@" "-p" ;;
    "--slis")   set -- "$@" "-i" ;;
    "--user")   set -- "$@" "-u" ;;
    "--pass")   set -- "$@" "-w" ;;
    "--help")   set -- "$@" "-h" ;;
    *)		set -- "$@" "$arg";;
  esac
done

OPTIND=1
slisNum=0
while getopts ":s:p:u:w:ih" opt; do
  case $opt in
    s)  server=$OPTARG >&2
	;;
    p)
        port=$OPTARG >&2
	;;
    i)
        case $opt in
          u)
            slisNum=($slisNum+1)
            username=$OPTARG >&2
            ;;
          u)
            slisNum=($slisNum+1)
            password=$OPTARG >&2
	    ;;
	esac

	if [ $slisNum -eq 2 ]
        then
          export {http,https,ftp}_proxy="$username:$password@http://172.0.16.1:3128"
        else
          echo "Avec le parametre [i|--slis], vous devez spécifier le nom d'utilsateur et le mot de passe du serveur SLIS."
          usage
	  exit
	fi
	;;
   h)
     usage
     unset {http,https,ftp}_proxy
     exit
     ;;
   \?)
     echo "Option invalide: -$OPTARG" >&2
     usage
     unset {http,https,ftp}_proxy
     exit
     ;;
   :)
     echo "L'option -$OPTARG nécéssite un argument." >&2
     usage
     unset {http,https,ftp}_proxy
     exit 1
     ;;
 esac
done

shift $(expr $OPTIND - 1)
if [ $OPTIND -eq 1 ]; then echo "No options were passed"; usage; exit; fi

connexion
getAndManageServerResponse
