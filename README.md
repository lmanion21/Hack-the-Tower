# Hack-the-Tower
## XE401 Hack the Tower Repo
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