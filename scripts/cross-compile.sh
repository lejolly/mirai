#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo -n "Installing gcc, electric-fence..."
apt-get install -y gcc electric-fence

echo "Creating folder /etc/xcompile"
mkdir /etc/xcompile > /dev/null 2>&1

mkdir ../cross-compile-bin > /dev/null 2>&1
cd ../cross-compile-bin
wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-i586.tar.bz2
echo "Copy cross-compiler-i586.tar.bz2 to /etc/xcompile"
cp cross-compiler-i586.tar.bz2 /etc/xcompile/cross-compiler-i586.tar.bz2

cd /etc/xcompile
echo "extracting cross-compiler-i586.tar.bz2 ..."
tar -jxf cross-compiler-i586.tar.bz2

echo "removing all tar.bz2 from /etc/xcompile ..."
rm *.tar.bz2
echo "move cross-compiler-i586 to i586 ..."
mv cross-compiler-i586 i586

echo "export PATH ..."
export PATH=$PATH:/etc/xcompile/i586/bin
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Documents/go
