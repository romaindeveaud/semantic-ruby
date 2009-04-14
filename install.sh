#!/bin/bash

echo "-- Semantic-ruby installer --"
if [ ! -r .semantic-rubyInstall ]
then 
  echo "\t **Error : unable to find directory .semantic-rubyInstall/ \n\tPlease launch the installer in the semantic-ruby root directory."
  exit
fi

echo -n "updating sources... "
apt-get update
echo "done"

echo -n "installing ruby essentials... "
apt-get install ruby-full build-essential
echo "done"

echo -n "installing rubygems... "
apt-get install rubygems
echo "done"

echo -n "creating symbolic links... "
ln -s $PWD/.semantic-rubyInstall/linkparser/link-grammar-4.4.1/link-grammar/.libs/liblink-grammar.so.4 /usr/lib/liblink-grammar.so.4
ln -s $PWD/.semantic-rubyInstall/wordnet-0.0.5/ruby-wordnet/ /usr/share/ruby-wordnet
echo "done"

echo -n "installing libdb4.2-dev... "
apt-get install libdb4.2-dev
echo "done"

echo -n "installing activesupport... "
gem install activesupport
echo "done"

echo -n "installing link-grammar... "
cd .semantic-rubyInstall/linkparser/link-grammar-4.4.1/ ;
./configure ;
make ;
make install ;
echo "done"

echo -n "installing bdb-0.6.5... "
cd ../../bdb-0.6.5 ;
make install ;
echo "done"
