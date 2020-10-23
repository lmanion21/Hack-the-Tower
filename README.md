# Hack-the-Tower
## XE401 Hack the Tower Repo
This Repoistory is the main working repository for USMA Hack the Tower.
Located here are scripts and instructions to set up a working 2G cell phone
tower using the nuande bladeRF and yatebts. The goal of this project is
to succesfully create or find exploits using a moblie base station.
### Instructions:
1. Run Scripts
2. `bladeRF-cli -l <path to fpga>`
3. `bladeRF-cli -f <load firmware>`
4. Navigate to yate folder 
    1. `./autogen.sh`
    2. `./configure --prefix=/usr/local`
    3. `make -j4`
    4. `sudo make install`
    6. `sudo ldconfig`
5. Navigate to yatebts folder 
    1. `./autogen.sh`
    2. `./configure --prefix=/usr/local`
    3. `make -j4`
    4. `sudo make install`
    6. `sudo ldconfig`
6. `cd /var/www/html/`
7. `sudo ln -s /usr/local/share/yate/nib_web nib`
8. `sudo chmod -R a+w /usr/local/etc/yate`
9. Navigate to `http://ip-of-your-rpi/nib` on your web browser

## References 
This project is based on work from the Army Cyber Institute and 
evilsocket.
[evilsocket](https://www.evilsocket.net/2016/03/31/how-to-build-your-own-rogue-gsm-bts-for-fun-and-profit/)
