#!/bin/bash

mkdir lolcow
cp singularity-2.5.2/examples/debian/Singularity lolcow/lolcow.recipe

cd lolcow/
cat >lolcow.recipe <<EOF
BootStrap: debootstrap
OSVersion: stable
#MirrorURL: http://ftp.us.debian.org/debian/
MirrorURL: http://mirrors.ustc.edu.cn/debian/

%runscript
    echo "This is what happens when you run the container..."
    fortune | cowsay | lolcat

%post
    echo "Hello from inside the container"
    apt-get update
    apt-get -y install fortune cowsay lolcat
    apt-get clean

%environment
    export PATH=$PATH:/usr/games
    export LC_ALL=C
EOF

# For debugging
sudo singularity build --sandbox lolcow.sandbox lolcow.recipe
sudo singularity shell --writable lolcow.sandbox

# For deployment
sudo singularity build lolcow.simg lolcow.recipe

# Execute user-defined commands
singularity exec lolcow.simg cowsay 'How did you get out of the container?'
# We can find that host and container share the same IPC namespacek.
singularity exec lolcow.simg cowsay moo > cowsaid
cat cowsaid | singularity exec lolcow.simg cowsay -n

# Use pipe in container like this
singularity exec lolcow.simg sh -c "fortune | cowsay | lolcat"

# There are serverla special dirrectories that Singularity bind mounts into
# your container by default. These include: $HOME /tmp /proc /sys and /dev.

# Mount /tmp/lolcow-datavl in host to /mnt in container
mkdir -p /tmp/lolcowvl && touch /tmp/lolcowvl/README
singularity exec --bind /tmp/lolcowvl:mnt lolcow.simg ls -l /mnt

# Instead, we counld set the variable $SINGULARTY_BINDPATH and the use our 
# container as before.
#export SINGULARITY_BINDPATH=/tmp/lolcowvl:/mnt
#singularity exec lolcow.simg ls -l /mnt

