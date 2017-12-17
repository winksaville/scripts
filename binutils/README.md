# Add the capability to support binutils 2.24 or 2.26

# Install binutils which is 2.24 on Ubuntu 14.04
sudo apt-get install binutils

# Copy binutils xxx to x86_64-linux-gunu-xxx
cp-binutils.sh

# Symlink target x86_64-linux-gnu-xxx to xxx-2.24

# Install binutils-2.26 which supports the above convention
sudo apt-get install binutils-2.26.sh

# Symlink target x86_64-linux-gnu-xxx-2.26 to xxx
binutils.sh 2.26

# Symlink target x86_64-linux-gnu-xxx-2.24 to xxx
binutils.sh 2.24
