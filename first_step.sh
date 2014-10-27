cd $HOME
sudo apt-get install -y git-core
sudo apt-get install -y curl
git clone https://github.com/coddeys/setup.git
chmod +x ./setup/*.sh
./setup/setup.sh
