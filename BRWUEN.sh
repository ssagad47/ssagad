#!/usr/bin/env bash

THIS_DIR=$(cd $(dirname $0); pwd)
cd $THIS_DIR

install() {
		sudo apt-get update -y
		sudo apt-get upgrade -y
		sudo apt-get install lua5.1 lua-socket lua-sec redis-server curl -y
		sudo apt-get install libreadline-dev libssl-dev lua5.2 luarocks liblua5.2-dev curl libcurl4-gnutls-dev -y
		git clone http://github.com/keplerproject/luarocks
		cd luarocks
		./configure --lua-version=5.2
		make build
		sudo make install
		sudo luarocks install Lua-cURL
		sudo luarocks install oauth
		sudo luarocks install redis-lua
		sudo luarocks install lua-cjson
		sudo luarocks install ansicolors
		sudo luarocks install serpent
		cd ..
}

function print_logo() {
	green "                                                                           "
	green "   ____  ______        ___   _ _____ _   _ 
             | __ )|  _ \ \      / / | | | ____| \ | |
             |  _ \| |_) \ \ /\ / /| | | |  _| |  \| |
             | |_) |  _ < \ V  V / | |_| | |___| |\  |
             |____/|_| \_\ \_/\_/   \___/|_____|_| \_|                                "
             
    green "                                                                           "
	green "                                                                           "
	echo -e "\n\e[0m"
}

function logo_play() {
    declare -A txtlogo
    seconds="0.010"
    txtlogo[1]="| __ )|  _ \ \      / / | | | ____| \ | |"
    txtlogo[2]="|  _ \| |_) \ \ /\ / /| | | |  _| |  \| |"
    txtlogo[3]="| |_) |  _ < \ V  V / | |_| | |___| |\  |"
    txtlogo[4]="|____/|_| \_\ \_/\_/   \___/|_____|_| \_|"
    printf "\e[31m\t"
    for i in ${!txtlogo[@]}; do
        for x in `seq 0 ${#txtlogo[$i]}`; do
            printf "${txtlogo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
    printf "\n"
	echo -e "\e[0m"
}

function BRWUENteam() {
	echo -e "\e[0m"
	green "     >>>>                       We Are Not Attacker                             "
	green "     >>>>                       We Are Not Alliance                             "
	white "     >>>>                       We Are Programmer                               "
	white "     >>>>                       We Are The Best                                 "
	red   "     >>>>                       We Are Family                                   "
	red   "     >>>>                       @vip_api                                    "
	echo -e "\e[0m"
}

red() {
  printf '\e[1;31m%s\n\e[0;39;49m' "$@"
}
green() {
  printf '\e[1;32m%s\n\e[0;39;49m' "$@"
}
white() {
  printf '\e[1;37m%s\n\e[0;39;49m' "$@"
}
update() {
	git pull
}

if [ "$1" = "install" ]; then
	print_logo
	BRWUENteam
	logo_play
	install
elif [ "$1" = "update" ]; then
	logo_play
	BRWUENteam
	update
	exit 1
else
	print_logo
	BRWUENteam
	logo_play
	green "BRWUEN Manager Bot running..."
	lua ./bot/bot.lua
fi
