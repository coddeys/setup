#!/bin/bash
# Simple setup.sh for configuring Ubuntu 13.10 EC2 instance
# for headless setup.

# Install git, curl
sudo apt-get install -y git
sudo apt-get install -y curl

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo add-apt-repository -y ppa:cassou/emacs
sudo apt-get -qq update
sudo apt-get install -y emacs24-nox emacs24-el emacs24-common-non-dfsg

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
mv .emacs.d .emacs.d~
fi
git clone https://github.com/coddeys/dotfiles.git
ln -sb dotfiles/.tmux.conf .
ln -sb dotfiles/.zshrc .
mv .emacs.d .emacs.d~
ln -s dotfiles/.emacs.d .
