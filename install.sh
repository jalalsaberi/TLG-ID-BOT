#!/bin/bash
# Compatible with Ubuntu ≥ 18 || Debian ≥ 10

magenta="\e[35m"
b_yellow="\e[93m"
cyan="\e[36m"
red="\e[31m"
green="\e[32m"
endl="\e[0m"

uninstall() {
    if [ -f "/etc/systemd/system/tlgidbot.service" ]; then
        systemctl stop tlgidbot.service
        systemctl disable tlgidbot.service
        rm -f /etc/systemd/system/tlgidbot.service
        rm -f $HOME/.tlgidbot.py
        systemctl daemon-reload
    fi
}

install() {
    apt install python3 python3-pip -y
    python_path=$(which python3)
    pip3 install python-telegram-bot==13.1
    if [ -f "/etc/systemd/system/tlgidbot.service" ]; then
        uninstall
    fi
    curl https://raw.githubusercontent.com/jalalsaberi/TLG-ID-BOT/main/tlgidbot.py > $HOME/.tlgidbot.py
    chmod +x $HOME/.tlgidbot.py
    clear
    echo -en "${magenta}Enter your Telegram Bot Token: ${endl}" && read token
    sed -i "s/TOKEN = ''/TOKEN = '$token'/" $HOME/.tlgidbot.py
    cat > "/etc/systemd/system/tlgidbot.service" << EOF
[Unit]
Description=Telegram ID Bot

[Service]
ExecStart=$python_path $HOME/.tlgidbot.py
Restart=always

[Install]  
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable tlgidbot.service > /dev/null
    systemctl start tlgidbot.service > /dev/null
    systemctl status tlgidbot.service
}

main() {
    clear
    echo -e "${b_yellow}Telegram ID Bot${endl}\n"
    echo -e "${cyan}1. Install${endl}\n${cyan}2. Uninstall${endl}\n"
    echo -en "${magenta}Choose: ${endl}" && read option
    if [[ $option == 1 ]]; then
        install
        echo -e "\n${green}Telegram ID Bot Installed Successfully${endl}\n"
    elif [[ $option == 2 ]]; then
        uninstall
        echo -e "\n${green}Telegram ID Bot Uninstalled Successfully${endl}\n"
    else
        echo -en "\n${red}Wrong Option!!! Choose again.${endl}\n"
        sleep 1.5
        main
    fi
}

main
