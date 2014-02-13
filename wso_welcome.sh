# Copy from https://gist.github.com/apelade/8203553
#! /bin/bash
#### Run like: source ./wso_welcome.sh
#### Change these if you want to use a different upstream or name for local:
 
UPSTREAM=https://github.com/AgileVentures/WebsiteOne
LOCAL=WebsiteOne
 
echo "
################### Info ####################
 
Install and config github/AgileVentures/WebsiteOne in current dir.
 
Upstream is hardcoded in the script as:
$UPSTREAM
Local repo to create is hardcoded in the script as:
$LOCAL
Edit those and re-run if you want to use other values.
"
read -p "Hit enter if you would like to run the script..."
if [ -d $LOCAL ] ; then
read -p "Directory ./$LOCAL exists. Exiting."
return 0
fi
 
 
echo "
################### Git #####################
"
echo
read -p "* Fork $UPSTREAM on github.com,
then come back and enter your github name: " NAME
git clone http://github.com/$NAME/WebsiteOne $LOCAL
cd $LOCAL
git remote add upstream $UPSTREAM
git fetch origin
git fetch upstream
 
echo "
################### RVM #####################
"
rvm requirements
rvm reload
rvm install ruby-2.0.0
ruby -v
rvm gemset create $LOCAL
echo "rvm 2.0.0@$LOCAL" >> .rvmrc
 
 
echo "
################ Dependencies ###############
"
bundle install

 
echo "
################ Postgres ###################
 
* Add a postgres user mapping in /etc/postgresql/9.1/main/
In pg_hba.conf, after 'local all postgres peer' add:
map=YourArbitraryName
YourArbitraryName can be anything, as long as it is the same in the next file."
read -p "* Hit Enter key to launch editor. Save and close to continue."
sudo nano /etc/postgresql/9.1/main/pg_hba.conf
echo "
############# Edit second file:
At the end of pg_ident.conf, add a line with the map name,
and your real user name:
YourArbitraryName **YourUserName** postgres"
read -p "* Hit Enter key to launch editor. Install continues after you close it."
sudo nano /etc/postgresql/9.1/main/pg_ident.conf
sudo /etc/init.d/postgresql reload
 
echo "
############ Rake db and test #############
"
git branch -a
read -p "* Name of origin tracking branch to checkout, or enter to skip: " BRANCH
if [ $BRANCH ] ; then
git checkout --track origin\/$BRANCH
fi
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:test:prepare
bundle exec rake db:seed
bundle exec rake spec
bundle exec rake cucumber --tags @javascript
