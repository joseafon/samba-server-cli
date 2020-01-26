# samba-server-cli
Install and manage samba like a standalone server from command line interface

## Language
Shell script (Bourne Shell)

## Prerequisites
Last version of Ubuntu, Debian or derivatives.
Do not have samba installed like a server or to delete the file: sudo rm /etc/samba/smb.conf and copy the new file: sudo cp /usr/samba/smb.conf /etc/samba

## Installation
git clone https://github.com/joseafon/samba-server-cli.git

## Setup
cd samba-server-cli && sudo chmod 700 admin.sh
The files will be stored in the path /etc/media/samba

## Run
sudo sh admin.sh
