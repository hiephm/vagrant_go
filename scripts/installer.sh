PROVISIONED="/home/vagrant/PROVISIONED";
CURRENT_VERSION=$(<PROVISIONED)

if [[ -f $PROVISIONED ]]; then
  echo "Already provisioned, checking for update...";
  
  if [[ $CURRENT_VERSION < 2 ]]; then
	# Update here
	echo 2 > $PROVISIONED;
  fi
  
  echo "DONE updating."
  exit;
fi

echo "################ FIRST TIME SETUP ################"
echo ">>>>>>>>>>>>>>>> Config timezone... <<<<<<<<<<<<<<<<"
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

echo ">>>>>>>>>>>>>>>> Config bash... <<<<<<<<<<<<<<<<"

echo ">>>>>>>>>>>>>>>> Essential tools... <<<<<<<<<<<<<<<<"
sudo apt-get update -q
sudo apt-get install -y zsh git vim tmux curl ncdu
sudo chsh -s /bin/zsh vagrant
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i "s|ZSH_THEME=.*|ZSH_THEME=\"avit\"|g" .zshrc
echo -e "\nsource /vagrant/conf/shell/.zshrc" >> ~/.zshrc
cp -r /vagrant/copied/home/. ~


echo ">>>>>>>>>>>>>>>> Installing Go... <<<<<<<<<<<<<<<<"
wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.8.linux-amd64.tar.gz

echo ">>>>>>>>>>>>>>>> Installing MySQL 5.7... <<<<<<<<<<<<<<<<"
sudo apt-key adv --recv-keys --keyserver keys.gnupg.net 5072E1F5
sudo apt-get update -q
sudo wget http://dev.mysql.com/get/mysql-apt-config_0.7.3-1_all.deb
echo 'mysql-apt-config        mysql-apt-config/select-server  select  mysql-5.7' | sudo debconf-set-selections 
sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.7.3-1_all.deb

echo 'mysql-server-5.7        mysql-server/root_password      password root' | sudo debconf-set-selections
echo 'mysql-server-5.7        mysql-server/root_password_again        password root' | sudo debconf-set-selections
sudo apt-get update -q
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
sudo cp -r /vagrant/copied/mysql/. /etc/mysql/mysql.conf.d/
sudo service mysql restart

sudo mysql -e "GRANT ALL ON *.* TO root@'192.168.%' IDENTIFIED BY 'root';"
# by default mysql 5.7 do not allow using password for root (auth_socket plugin), to change root@localhost password, using: 
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"


echo ">>>>>>>>>>>>>>>> Installing XFCE4 ... <<<<<<<<<<<<<<<<"
sudo apt-get install -y xfce4 xfce4-goodies lightdm
sudo apt-get purge -y xscreensaver

echo ">>>>>>>>>>>>>>>> Installing Gogland ... <<<<<<<<<<<<<<<<"
wget https://download.jetbrains.com/go/gogland-171.3780.106.tar.gz
sudo mkdir /opt/gogland
sudo tar zx -C /opt/gogland --strip-components 1 -f gogland-171.3780.106.tar.gz
sudo ln -s /opt/gogland/bin/gogland.sh /usr/local/bin/gogland

echo 1 > $PROVISIONED;