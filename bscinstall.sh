#!/bin/bash

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m This script will install BSC node!\e[0m"
echo -e "\e[32m Do you want to proceed?\e[0m"
echo -n -e "\e[31m Please choose [Y|N]: \e[0m"
read input

if [[ $input == "N" || $input == "n" ]]; then
echo "exit"

else
echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m The installation of the software is in progress!\e[0m"
apt update -y > /dev/null 2>&1
apt upgrade -y > /dev/null 2>&1
apt install make linux-libc-dev gcc unzip screen pwgen wget git cmake libc6-dev -y > /dev/null 2>&1

cd /usr/src

wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz > /dev/null 2>&1

rm -rf /usr/local/go
tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz > /dev/null

userpass=$(pwgen 10 1)
useradd -m -p $userpass bsc

usermod -aG sudo bsc

export PATH=$PATH:/usr/local/go/bin; echo "export PATH=$PATH:/usr/local/go/bin" >> /home/bsc/.profile

cd /home/bsc
git clone https://github.com/binance-chain/bsc > /dev/null 2>&1
mv bsc nodebsc; cd /home/bsc/nodebsc

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m Building 'geth' binary file!\e[0m"
make geth > /dev/null 2>&1

wget https://github.com/binance-chain/bsc/releases/download/v1.1.0-beta/testnet.zip > /dev/null 2>&1

unzip testnet.zip > /dev/null 2>&1

sudo ln -s /home/bsc/nodebsc/build/bin/geth /usr/local/bin/geth

/usr/local/bin/geth --datadir node init genesis.json >> /dev/null 2>&1

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m Configure bash script /home/bsc/script!\e[0m"

mkdir /home/bsc/script/

echo '#!/bin/bash' >> /home/bsc/script/bsc.sh
echo '/usr/local/bin/geth --config /home/bsc/nodebsc/config.toml --datadir /home/bsc/nodebsc/node --cache 18000 --rpc.allow-unprotected-txs --txlookuplimit 0 --ws --ws.api eth' >> /home/bsc/script/bsc.sh

chmod +x /home/bsc/script/bsc.sh
chown -R bsc:bsc /home/bsc/*

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m Creating systemd service!\e[0m"

printf "[Unit]
Description=BSC daemon
After=network-online.target

[Service]
User=bsc
ExecStart=/bin/bash /home/bsc/script/bsc.sh
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/bsc.service

echo 'bsc ALL=NOPASSWD: /bin/systemctl' >> /etc/sudoers

sudo systemctl daemon-reload
sudo systemctl enable bsc.service
su bsc -c "sudo systemctl restart bsc"

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[31m Please save BSC user password!!!\e[0m"
echo -e "\e[32m" $userpass "\e[0m"

echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[31m To check the sync status, please run: \e[0m"
echo -e "\e[32m geth attach ws://localhost:8576 \e[0m"
echo -e "\e[34m --------------------------------------\e[0m"
echo -e "\e[32m eth.syncing \e[0m"
fi
