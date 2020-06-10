#!/bin/bash
set -e
export LC_ALL="en_US.UTF-8"
PACGlobalLocation="/root/PACGlobal/"
OutputLocation="/var/www/html/"

echo ""
echo "#################################################"
echo "#          Updating Bootstrap Files             #"
echo "#################################################"
echo ""
echo "Stopping PACGlobal Daemon Service..."
cd $PACGlobalLocation
systemctl stop pacg.service

sleep 2

if [ ! -d $OutputLocation ]; then
    echo "Creating Output $OutputLocation..."
    mkdir $OutputLocation
fi

echo "Putting necessary data to BootstrapNew.tar.gz..."

cd ~/.PACGlobal
tar --overwrite -zcvf "$OutputLocation/BootstrapNew.tar.gz" blocks chainstate evodb peers.dat
cd $OutputLocation
sleep 2
if [ -f "BootstrapNew.tar.gz" ]; then
    BootstrapNewSize=$(wc -c "$OutputLocation/BootstrapNew.tar.gz" | awk '{print $1}')

    if [ $BootstrapNewSize -gt 100000 ]; then
        echo "Replacing BootstrapNew.tar.gz to Bootstrap.tar.gz...";
        mv "BootstrapNew.tar.gz" "Bootstrap.tar.gz"
    else
        echo "[ERROR] BootstrapNew.tar.gz seems to be too small - Something is wrong."
        rm -rf "BootstrapNew.tar.gz"
    fi
else
    echo "[ERROR] BootstrapNew.tar.gz doesn't exsits. Something went wrong.";
fi

echo "Starting PACGlobal Daemon Service..."
cd $PACGlobalLocation
systemctl start pacg.service

echo "Bootstrap has been updated!"
exit
