sudo apt-get update ;
sudo apt-get install subversion ruby irb rdoc libc6-dev libopenssl-ruby ruby1.8-dev tcl-dev tk-dev libdb4.2 libdb4.2-dev ;
cd ~ ;
mkdir .semantic-rubyInstall ;
cd .semantic-rubyInstall ;
echo "Installing RubyGems 1.3.1..." ; 
wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz ;
tar xzf rubygems-1.3.1.tgz ;
cd rubygems-1.3.1 ;
sudo ruby setup.rb ;
sudo gem1.8 install rake rdoc rcov rspec diff-lcs activesupport ;
cd .. ; 
mkdir linkparser ; 
cd linkparser ;
svn co svn://deveiate.org/Ruby-LinkParser2/trunk . ;
tar xzf link-grammar-4.4.1.tar.gz ;
cd link-grammar-4.4.1 ;
./configure ; make ;
sudo make install ;
cd .. ;
echo "Installing LinkParser..." ;
export LD_LIBRARY_PATH=/usr/local/lib ;
rake ; sudo rake install ;
cd .. ;
wget http://www.deveiate.org/code/wordnet-0.0.5.tar.gz ;
wget http://wordnet.princeton.edu/3.0/WordNet-3.0.tar.gz ;
wget ftp://moulon.inra.fr/pub/ruby/bdb-0.6.5.tar.gz ;
tar xzf wordnet-0.0.5.tar.gz ;
tar xzf WordNet-3.0.tar.gz ;
tar xzf bdb-0.6.5.tar.gz ;
cd WordNet-3.0 ;
./configure ; make ;
sudo make install ;
cd ../bdb-0.6.5 ;
ruby extconf.rb ;
make ;
sudo make install ;
cd ../wordnet-0.0.5 ;
echo -e "\033[31;1m ==== Press 'y' when prompted first time, and 'Enter' when prompted second time ==== \033[0m" ;
ruby convertdb.rb ;
rake ;
sudo rake install ;
cd /usr/share ;
sudo mkdir ruby-wordnet ;
sudo cp ~/.semantic-rubyInstall/wordnet-0.0.5/ruby-wordnet/* ruby-wordnet ;
sudo chown -R $USER ruby-wordnet ;
cd ~/.semantic-rubyInstall ;
mkdir linguistics ; cd linguistics ;
svn co svn://deveiate.org/Linguistics/trunk . ;
rake ;
sudo rake install ;
echo "export LPPATH=/home/$USER/.semantic-rubyInstall/linkparser" >> /home/$USER/.bashrc ;
echo "export WNPATH=/home/$USER/.semantic-rubyInstall/wordnet-0.0.5" >> /home/$USER/.bashrc ;
echo "export LANG=en_US.UTF-8" >> /home/$USER/.bashrc ;
echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /home/$USER/.bashrc ;
export LPPATH=/home/$USER/.semantic-rubyInstall/linkparser
export WNPATH=/home/$USER/.semantic-rubyInstall/wordnet-0.0.5
export LANG=en_US.UTF-8
cd .. ;
rm -f *.tar.gz *.tgz ;
