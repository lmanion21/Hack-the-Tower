# Hack-the-Tower
## XE401 Hack the Tower Repo
This Repoistory is the main working repository for USMA Hack the Tower.
Located here are scripts and instructions to set up a working 2G cell phone
tower using the nuande bladeRF and yatebts. The goal of this project is
to succesfully create or find exploits using a moblie base station.
### Instructions:
1. First, we must run our scripts. Start by navigating to running `./pkg_install.sh` and `./yatebts_install` under the correct OS.
2. Next, we need to lod the image and the firmware onto the bladeRF. 
    1. `bladeRF-cli -l <path to fpga>`
    2. `bladeRF-cli -f <load firmware>`
3. now we need to compile yate software. Navigate to yate folder 
    1. `./autogen.sh`
    2. `./configure --prefix=/usr/local`
    3. `make -j4`
    4. `sudo make install`
    6. `sudo ldconfig`
4. Navigate to yatebts folder 
    1. `./autogen.sh`
    2. `./configure --prefix=/usr/local`
    3. `make -j4`
    4. `sudo make install`
    6. `sudo ldconfig`
5. Now we will set up the yatebts web server.
    1. `cd /var/www/html/`
    2. `sudo ln -s /usr/local/share/yate/nib_web nib`
    3. `sudo chmod -R a+w /usr/local/etc/yate`
6. See if your server is up and running by navigating to `http://ip-of-your-rpi/nib` on your web browser.
7. Start your base station 
    1. `sudo yate -s`

## References 
This project is based on work from the Army Cyber Institute and 
[evilsocket](https://www.evilsocket.net/2016/03/31/how-to-build-your-own-rogue-gsm-bts-for-fun-and-profit/).

## 4G LTE with srsLTE
1. Install on Ubuntu with: sudo add-apt-repository ppa:srslte/releases
sudo apt-get update
sudo apt-get install srslte -y

The srsLTE suite includes:
srsUE - a complete SDR LTE UE (User Equipment) application
srsENB - a complete SDR LTE eNodeB (Basestation) application
srsEPC - a light-weight LTE EPC (Core Network) implementation with MME, HSS and S/P-GW

srsLTE documentation: https://docs.srslte.com/en/latest/

2. Replace the srsEPC with NextEPC
sudo apt-get update
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:nextepc/nextepc
sudo apt-get update
sudo apt-get -y install nextepc

Install Web Interface: 
sudo apt-get -y install curl
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
curl -sL https://nextepc.org/static/webui/install | sudo -E bash -

Verify the Installation: 
sudo systemctl status nextepc-mmed
● nextepc-mmed.service - NextEPC MME Daemon
   Loaded: loaded (/lib/systemd/system/nextepc-mmed.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2019-02-21 19:29:43 MST; 27s ago
   ...
sudo systemctl status nextepc-sgwd
   ...
sudo systemctl status nextepc-pgwd
   ...
sudo systemctl status nextepc-hssd
   ...
sudo systemctl status nextepc-pcrfd
   ...

Verify the tunnel interface creation
ifconfig pgwtun
pgwtun    Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  
          inet addr:45.45.0.1  P-t-P:45.45.0.1  Mask:255.255.0.0
          inet6 addr: fe80::50f6:182c:5aa3:16bb/64 Scope:Link
          inet6 addr: cafe::1/64 Scope:Global
          ...

More on https://nextepc.org/installation/02-ubuntu/. 

## References 
This project is based on work by [srsLTE](https://github.com/srslte/srslte).
