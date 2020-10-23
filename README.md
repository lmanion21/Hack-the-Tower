# Hack-the-Tower
## XE401 Hack the Tower Repo
### Instructions:
1. Run Scripts
2. bladeRF-cli -l <path to fpga>
3. bladeRF-cli -f <load firmware>
4. Navigate to yate folder 
./autogen.sh
./configure --prefix=/usr/local
make -j4
sudo make install
sudo ldconfig
cd ..