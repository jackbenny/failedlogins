#!/bin/bash

# Jack-Benny Persson
# LX13
# Configuration script to update the hardcoded binaries

Binaries=(sed awk egrep mail printf cat grep mktemp rm tail)

# Check that they are all installed

for bin in ${Binaries[@]}; do
	whereis $bin | awk '{ print $2 }' | grep $bin &> /dev/null
	if [ $? -ne 0 ]; then
		echo "It seems you system dosen't have $bin installed"
		exit 1
	fi
done

for i in ${Binaries[@]}; do

	
