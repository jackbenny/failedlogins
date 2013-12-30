#!/bin/bash

# Jack-Benny Persson
# LX13
# Configuration script to update the hardcoded binaries

# Variables
Binaries=(sed awk egrep mail printf cat grep mktemp rm tail)
File="failed_logins.sh"
TempFile=`mktemp -t failed_logins.XXXXXX`
StartBin=8
EndBin=17

# Check that they are all installed
for bin in ${Binaries[@]}; do
	whereis $bin | awk '{ print $2 }' | grep $bin &> /dev/null
	if [ $? -ne 0 ]; then
		echo "It seems you system dosen't have $bin installed"
		exit 1
	fi
done

# Make a temporary copy of the original file
cp $File $TempFile

# Loop through all the binaries to extract the path and make new
# variables for the script looking like this: Binary="/bin/binary"
Index=0
for i in ${Binaries[@]}; do
	NewBins[$Index]=$(echo "$i=\"`whereis $i | awk '{ print $2 }'`\"" | \
		sed "s/\b\(^.\)/\u\1/g")
	((Index++))
done

# Replace the old variables for the new ones
cat $TempFile | sed "{
/Sed=/c${NewBins[0]}
/Awk=/c${NewBins[1]}
/Egrep=/c${NewBins[2]}
/Mail=/c${NewBins[3]}
/Printf=/c${NewBins[4]}
/Cat=/c${NewBins[5]}
/Grep=/c${NewBins[6]}
/Mktemp=/c${NewBins[7]}
/Rm=/c${NewBins[8]}
/Tail=/c${NewBins[9]}
}" > $File

# Clean up
rm $TempFile

exit 0
