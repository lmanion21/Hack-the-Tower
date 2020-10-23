# Hack-the-Tower
## XE401 Hack the Tower Repo
### Instructions:
1. Run Scripts
2. bladeRF-cli -l <path to fpga>
3. bladeRF-cli -f <load firmware>
4. Navigate to yate folder 
    1. ./autogen.sh
    2. ./configure --prefix=/usr/local
    3. make -j4
    4. sudo make install
    6. sudo ldconfig
    7. cd ..