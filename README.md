# install_bsc_node
This repository contains script to install and configure BSC node on the server

## Requirements
There are no special requirements. The bash script will install all necessary software and perform all configuration automatically

You just need to install 'wget' tool to make possibility run and install it:
```
sudo apt install wget -y
```

## Feauters
- No features

## Notes
- Please note: This script will install the BSC node with all necessary components and run it on behalf of "bsc" user.
 
## Installation
To configure and install BSC Node please run:
```
sudo wget wget https://raw.githubusercontent.com/AntonMashnin/install_bsc_node/main/bscinstall.sh
sudo chmod +x bscinstall.sh
sudo ./bscinstall.sh
```
