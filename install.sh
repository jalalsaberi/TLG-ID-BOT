#!/bin/bash
# Compatible with Ubuntu ≥ 18 || Debian ≥ 10

MAGENTA="\e[35m"
END="\e[0m"

apt update -y
apt install python3 python3-pip -y
python_path=$(which python3)
pip3 install python-telegram-bot==13.1
if [ -f "/etc/systemd/system/tlgidbot.service" ]; then
    systemctl stop tlgidbot.service
    systemctl disable tlgidbot.service
    rm -f /etc/systemd/system/tlgidbot.service
    rm -f $HOME/.tlgidbot.py
    systemctl daemon-reload
fi
curl https://raw.githubusercontent.com/jalalsaberi/TLG-ID-BOT/main/tlgidbot.py > $HOME/.tlgidbot.py
chmod +x $HOME/.tlgidbot.py
clear
echo -en "${MAGENTA}Enter your Telegram Bot Token: ${END}" && read token
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
echo -en "\n${MAGENTA}Telegram ID Bot Installed Successfully${END}\n"
