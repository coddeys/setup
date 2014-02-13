#!/bin/bash
# Simple setup.sh for configuring Ubuntu 13.10 EC2 instance

# Add emacs24 repository
sudo add-apt-repository -y ppa:cassou/emacs
sudo apt-get -qq update

# Install git, curl, zsh, emacs, tmux
sudo apt-get install -y git curl git-core zsh emacs24-nox emacs24-el emacs24-common-non-dfsg tmux postgresql postgresql-contrib libpq-dev libqtwebkit-dev libpq-dev nodejs bundler

# Create postgres user
sudo -u postgres psql postgres

# Install Heroku toolbelt
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Install oh-my-zsh 
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# RVM stable with ruby
\curl -sSL https://get.rvm.io | bash -s stable --ruby

# GitAuth - SSH-based authentication for Shared Git Repositories.
sudo gem install gitauth


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
