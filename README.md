# install_bsc_node
This repository contains script to install BSC node

This is a bash script to install BSC node on the server

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
To configure "srvstat" tool please run:
```
sudo wget https://raw.githubusercontent.com/AntonMashnin/agoric-srv-monitor/main/monitoring.sh
sudo chmod +x monitoring.sh
sudo ./monitoring.sh
```
