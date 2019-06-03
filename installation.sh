#!/bin/bash

 sudo apt -y install python build-essential debootstrap squashfs-tools libarchive-dev

 wget https://github.com/singularityware/singularity/releases/download/2.5.2/singularity-2.5.2.tar.gz && \
     tar -xf singularity-2.5.2.tar.gz 
 cd singularity-2.5.2/
 ./configure --prefix=/usr/local
 make -j
 sudo make install

 . etc/bash_completion.d/singularity
 cp etc/bash_completion.d/singularity /etc/bash_completion.d/

 singularity run docker://godlovedc/lolcow
