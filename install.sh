#!/bin/bash

if [[ $(uname -i) == "x86_64" ]]; then
	echo "64"
	dpkg -i /drivers/JLink_Linux_V754b_x86_64.deb
else
	echo "32"
	dpkg -i /drivers/JLink_Linux_V754b_i386.deb
fi

