#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "*                                                                          *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [ $DOSETUP = "y" ]  
then
 
apt-get update -y
#DEBIAN_FRONTEND=noninteractive apt-get update 
#DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade
apt install -y software-properties-common 
apt-add-repository -y ppa:bitcoin/bitcoin 
apt-get update -y
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget pwgen curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev  libdb5.3++ unzip 



fallocate -l 4G /wswapfile
chmod 600 /wswapfile
mkswap /wswapfile
swapon /wswapfile
swapon -s
echo "/wswapfile none swap sw 0 0" >> /etc/fstab

fi
  wget https://github.com/duality-solutions/Dynamic/releases/download/v2.5.0.0/Dynamic-2.5.0.0-Linux-x64.tar.gz
  
  #wget https://github.com/wagerr/Wagerr-Blockchain-Snapshots/releases/download/Block-826819/826819.zip -O bootstrap.zip
  #export fileid=1VqdvSvolhpwOoYgaoSHkZkmRla2kl27R
  #export filename=wagerr-3.1.0-x86_64-linux-gnu.tar.gz
  #wget --save-cookies cookies.txt 'https://docs.google.com/uc?export=download&id='$fileid -O- \
  #   | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p' > confirm.txt

  #wget --load-cookies cookies.txt -O $filename \
  #   'https://docs.google.com/uc?export=download&id='$fileid'&confirm='$(<confirm.txt)

  export fileid=1DfgPH_HLu_rwjFIVSyYnkvjYbSY8UKh2
  export filename=bootstrap.zip
  wget --save-cookies cookies.txt 'https://docs.google.com/uc?export=download&id='$fileid -O- \
     | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p' > confirm.txt

  wget --load-cookies cookies.txt -O $filename \
     'https://docs.google.com/uc?export=download&id='$fileid'&confirm='$(<confirm.txt)
  tar xvzf Dynamic-2.5.0.0-Linux-x64.tar.gz
  
  
  chmod +x ~/bin/*
  sudo mv  ~/bin/* /usr/local/bin
  rm -rf Dynamic-2.5.0.0-Linux-x64.tar.gz

  sudo apt install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc


 ## Setup conf
 IP=$(curl -s4 api.ipify.org)
 mkdir -p ~/bin
 echo ""
 echo "Configure your masternodes now!"
 echo "Detecting IP address:$IP"

echo ""
echo "How many nodes do you want to create on this server? [min:1 Max:20]  followed by [ENTER]:"
read MNCOUNT


for i in `seq 1 1 $MNCOUNT`; do
  echo ""
  echo "Enter alias for new node"
  read ALIAS  

  echo ""
  echo "Enter port for node $ALIAS"
  read PORT

  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY

  RPCPORT=$(($PORT*10))
  echo "The RPC port is $RPCPORT"

  ALIAS=${ALIAS}
  CONF_DIR=~/.dynamic_$ALIAS
  
  #fallocate -l 1.5G /swapfile$ALIAS
  #chmod 600 /swapfile$ALIAS
  #mkswap /swapfile$ALIAS
  #swapon /swapfile$ALIAS
  #swapon -s
  #echo "/swapfile$ALIAS none swap sw 0 0" >> /etc/fstab

  # Create scripts
  echo '#!/bin/bash' > ~/bin/dynamicd_$ALIAS.sh
  echo "dynamicd -daemon -conf=$CONF_DIR/dynamic.conf -datadir=$CONF_DIR "'$*' >> ~/bin/dynamicd_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/dynamic-cli_$ALIAS.sh
  echo "dynamic-cli -conf=$CONF_DIR/dynamic.conf -datadir=$CONF_DIR "'$*' >> ~/bin/dynamic-cli_$ALIAS.sh
  #echo '#!/bin/bash' > ~/bin/dynamic-tx_$ALIAS.sh
  #echo "dynamic-tx -conf=$CONF_DIR/dynamic.conf -datadir=$CONF_DIR "'$*' >> ~/bin/dynamic-tx_$ALIAS.sh 
  chmod 755 ~/bin/dynamic*.sh

  mkdir -p $CONF_DIR
  unzip  bootstrap.zip -d $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> dynamic.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> dynamic.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> dynamic.conf_TEMP
  echo "rpcport=$RPCPORT" >> dynamic.conf_TEMP
  echo "listen=1" >> dynamic.conf_TEMP
  echo "server=1" >> dynamic.conf_TEMP
  echo "daemon=1" >> dynamic.conf_TEMP
  echo "logtimestamps=1" >> dynamic.conf_TEMP
  echo "maxconnections=256" >> dynamic.conf_TEMP
  echo "masternode=1" >> dynamic.conf_TEMP
  echo "" >> dynamic.conf_TEMP
  echo "addnode=[2001:41d0:700:47e::]:33300" >> dynamic.conf_TEMP
  echo "addnode=[2a01:e0a:ee:fb30:9a90:96ff:fed6:b450]:33300" >> dynamic.conf_TEMP
  echo "addnode=116.203.56.43:33300" >> dynamic.conf_TEMP
  echo "addnode=135.181.52.135:33300" >> dynamic.conf_TEMP
  echo "addnode=136.243.29.195:33300" >> dynamic.conf_TEMP
  echo "addnode=159.69.83.47:33300" >> dynamic.conf_TEMP
  echo "addnode=161.97.141.76:33300" >> dynamic.conf_TEMP
  echo "addnode=168.119.80.4:33300" >> dynamic.conf_TEMP
  echo "addnode=168.119.87.193:33300" >> dynamic.conf_TEMP
  echo "addnode=168.119.87.195:33300" >> dynamic.conf_TEMP
  echo "addnode=176.9.210.2:33300" >> dynamic.conf_TEMP
  echo "addnode=178.62.5.100:33300" >> dynamic.conf_TEMP
  echo "addnode=178.63.121.129:33300" >> dynamic.conf_TEMP
  echo "addnode=178.63.235.193:33300" >> dynamic.conf_TEMP
  echo "addnode=188.40.163.3:33300" >> dynamic.conf_TEMP
  echo "addnode=188.40.184.65:33300" >> dynamic.conf_TEMP
  echo "addnode=192.210.228.215:33300" >> dynamic.conf_TEMP
  echo "addnode=195.201.207.24:33300" >> dynamic.conf_TEMP
  echo "addnode=51.15.129.216:33300" >> dynamic.conf_TEMP
  echo "addnode=51.15.46.203:33300" >> dynamic.conf_TEMP
  echo "addnode=51.15.51.189:33300" >> dynamic.conf_TEMP
  echo "addnode=51.15.60.147:33300" >> dynamic.conf_TEMP
  echo "addnode=51.15.61.31:33300" >> dynamic.conf_TEMP
  echo "addnode=8.9.6.89:33300" >> dynamic.conf_TEMP
  echo "addnode=88.99.11.0:33300" >> dynamic.conf_TEMP
  echo "addnode=88.99.11.2:33300" >> dynamic.conf_TEMP
  echo "addnode=88.99.11.3:33300" >> dynamic.conf_TEMP
  echo "addnode=94.130.184.73:33300" >> dynamic.conf_TEMP
  echo "addnode=95.216.109.132:33300" >> dynamic.conf_TEMP
  echo "addnode=95.216.79.232:33300" >> dynamic.conf_TEMP
  echo "addnode=95.217.48.101:33300" >> dynamic.conf_TEMP
  echo "addnode=95.217.48.102:33300" >> dynamic.conf_TEMP
  echo "addnode=164.68.125.170" >> dynamic.conf_TEMP
  echo "addnode=155.138.218.41" >> dynamic.conf_TEMP
  echo "addnode=116.202.47.198" >> dynamic.conf_TEMP
  echo "addnode=108.61.144.241" >> dynamic.conf_TEMP
  echo "addnode=217.67.229.223" >> dynamic.conf_TEMP
  echo "addnode=190.96.1.19" >> dynamic.conf_TEMP
  echo "addnode=86.122.44.179" >> dynamic.conf_TEMP
  echo "addnode=216.128.140.18" >> dynamic.conf_TEMP
  echo "addnode=190.96.1.19" >> dynamic.conf_TEMP
  echo "addnode=51.15.120.57" >> dynamic.conf_TEMP
  echo "addnode=172.112.30.148" >> dynamic.conf_TEMP
  echo "addnode=46.123.236.190" >> dynamic.conf_TEMP
  echo "addnode=174.4.72.251" >> dynamic.conf_TEMP
  echo "addnode=172.111.162.167" >> dynamic.conf_TEMP
  echo "addnode=69.14.75.223" >> dynamic.conf_TEMP
  echo "addnode=188.27.146.159" >> dynamic.conf_TEMP
  echo "" >> dynamic.conf_TEMP
  echo "port=$PORT" >> dynamic.conf_TEMP
  echo "masternodeaddr=$IP:33300" >> dynamic.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> dynamic.conf_TEMP
  sudo ufw allow $PORT/tcp

  mv dynamic.conf_TEMP $CONF_DIR/dynamic.conf
  
  #sh ~/bin/wagerrd_$ALIAS.sh
  
  cat << EOF > /etc/systemd/system/dynamic_$ALIAS.service
[Unit]
Description=dynamic_$ALIAS service
After=network.target
[Service]
User=root
Group=root
Type=forking
ExecStart=/usr/local/bin/dynamicd -daemon -conf=$CONF_DIR/dynamic.conf -datadir=$CONF_DIR
ExecStop=/usr/local/bin/dynamic-cli -conf=$CONF_DIR/dynamic.conf -datadir=$CONF_DIR stop
Restart=always
PrivateTmp=true
RestartSec=1
StartLimitInterval=0
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 10
  systemctl start dynamic_$ALIAS.service
  systemctl enable dynamic_$ALIAS.service >/dev/null 2>&1

  #(crontab -l 2>/dev/null; echo "@reboot sh ~/bin/wagerrd_$ALIAS.sh") | crontab -
#	   (crontab -l 2>/dev/null; echo "@reboot sh /root/bin/wagerrd_$ALIAS.sh") | crontab -
#	   sudo service cron reload
  
done
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
