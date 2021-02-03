
# Script to install EFS Utils on Ubuntu/Debian

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get -y install git binutils
git clone https://github.com/aws/efs-utils
cd efs-utils/
./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb

sudo hostname ssh-srv
