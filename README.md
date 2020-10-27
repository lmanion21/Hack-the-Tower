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
