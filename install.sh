#chromebrew directories
OWNER="jbaum98"
REPO="chromebrew"
BRANCH="linuxbrew_install"
URL="https://raw.github.com/$OWNER/$REPO/$BRANCH"
CREW_PREFIX=/usr/local
CREW_PATH=$CREW_PREFIX/chromebrew
CREW_LIB=$CREW_PATH/lib
CREW_SRC=$CREW_PATH/sources
CREW_FORMULAS=$CREW_PATH/packages

user=$(whoami)
architecture=$(uname -m)

if [ $architecture != "i686" ] && [ $architecture != "x86_64" ]; then
  echo 'Your device is not supported by Chromebrew yet.'
  exit 1;
fi

#prepare directories
sudo mkdir -p $CREW_LIBS && sudo chown -R $user:$user $CREW_LIB
sudo mkdir -p $CREW_SRC && sudo chown -R $user:$user $CREW_SRC
sudo mkdir -p $CREW_FORMULAS && sudo chown -R $user:$user $CREW_FORMULAS

#cd into the brew directory, everything will happen there
cd $CREW_SOURCES

#download ruby
echo "Downloading ruby..."

case "$architecture" in
"i686")
  link='https://dl.dropboxusercontent.com/s/tufbuqcn80ubypx/ruby-2.0.0p247-chromeos-i686.tar.gz?token_hash=AAGu_5wuqZe2eDOkfL5oh4esQ8HAZJIvbMG7GplnQrSa3g&dl=1'
  tarname='ruby-2.0.0p247-chromeos-'$architecture'.tar.gz'
  ;;
"x86_64")
  link='https://dl.dropboxusercontent.com/s/3dw5ue5vhf5nj8k/ruby-2.0.0-p247-chromeos1-chromeos-x86_64.tar.gz?dl=1&token_hash=AAHYJ-WOExuc2f4mKN3pDHUOlTMnt3h-rBosLmYr2Gvy7w'
  tarname='ruby-2.0.0-p247-chromeos1-chromeos-'$architecture'.tar.gz'
  ;;
esac

wget --continue --no-check-certificate --content-disposition $link -O $tarname

#extract and install ruby
echo "Extracting ruby (this may take a while)..."
tar -xf $tarname
echo "Installing ruby (this may take a while)..."
sudo cp -r ./usr/* /usr

#download, prepare and install chromebrew
cd $CREW_LIB_PATH
wget -N --continue --no-check-certificate $URL/crew
chmod +x crew
sudo ln -s `pwd`/crew $CREW_PREFIX/bin
#install crew library
mkdir $CREW_LIB_PATH/lib && cd $CREW_LIB_PATH/lib
wget -N --continue --no-check-certificate $URL/lib/package.rb
wget -N --continue --no-check-certificate $URL/lib/package_helpers.rb
#create the device.json file
cd $CREW_CONFIG_PATH
touch device.json
echo "{" > device.json
echo '  "architecture": "'$architecture'",' >> device.json
echo '  "installed_packages": [' >> device.json
echo '    {' >> device.json
echo '      "name": "ruby",' >> device.json
echo '      "version": "2.0.0p247"' >> device.json
echo '    }' >> device.json
echo '  ]' >> device.json
echo "}" >> device.json

#download git and its dependencies .rb package files
cd $CREW_PACKAGES_PATH
wget -N --continue --no-check-certificate $URL/packages/git.rb
wget -N --continue --no-check-certificate $URL/packages/zlibpkg.rb
wget -N --continue --no-check-certificate $URL/packages/libssh2.rb
wget -N --continue --no-check-certificate $URL/packages/perl.rb
wget -N --continue --no-check-certificate $URL/packages/openssl.rb
wget -N --continue --no-check-certificate $URL/packages/curl.rb
wget -N --continue --no-check-certificate $URL/packages/expat.rb
wget -N --continue --no-check-certificate $URL/packages/gettext.rb
wget -N --continue --no-check-certificate $URL/packages/python.rb
wget -N --continue --no-check-certificate $URL/packages/readline.rb
wget -N --continue --no-check-certificate $URL/packages/ruby.rb
wget -N --continue --no-check-certificate $URL/packages/buildessential.rb
wget -N --continue --no-check-certificate $URL/packages/gcc.rb
wget -N --continue --no-check-certificate $URL/packages/binutils.rb
wget -N --continue --no-check-certificate $URL/packages/make.rb
wget -N --continue --no-check-certificate $URL/packages/mpc.rb
wget -N --continue --no-check-certificate $URL/packages/mpfr.rb
wget -N --continue --no-check-certificate $URL/packages/gmp.rb
wget -N --continue --no-check-certificate $URL/packages/glibc.rb
wget -N --continue --no-check-certificate $URL/packages/linuxheaders.rb

#install readline for ruby
(echo y;) | crew install readline

#install git
(echo y;) | crew install git

#prepare sparse checkout .rb packages directory and do it
cd $CREW_LIB_PATH
git init
git remote add -f origin https://github.com/$OWNER/$REPO.git
git config core.sparsecheckout true
echo packages >> .git/info/sparse-checkout
echo lib >> .git/info/sparse-checkout
echo crew >> .git/info/sparse-checkout
git fetch origin master
git reset --hard origin/master
echo "Chromebrew installed successfully and package lists updated."
