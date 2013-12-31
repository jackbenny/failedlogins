#!/bin/bash

################################################################################
#                                                                              #
#  Copyright (C) 2013 Jack-Benny Persson <jack-benny@cyberinfo.se>             #
#                                                                              #
#   This program is free software; you can redistribute it and/or modify       #
#   it under the terms of the GNU General Public License as published by       #
#   the Free Software Foundation; either version 2 of the License, or          #
#   (at your option) any later version.                                        #
#                                                                              #
#   This program is distributed in the hope that it will be useful,            #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#   GNU General Public License for more details.                               #
#                                                                              #
#   You should have received a copy of the GNU General Public License          #
#   along with this program; if not, write to the Free Software                #
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA  #
#                                                                              #
################################################################################

# failedlogins
# Version 0.1

# Variables
Binaries=(sed awk egrep mail printf cat grep mktemp rm tail)
File="failedlogins.sh"
TempFile=`mktemp -t failedlogins.XXXXXX`
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
