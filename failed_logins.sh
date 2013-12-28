#!/bin/bash

# Jack-Benny Persson
# LX13
# Exercise 5 on lab 8 (Write a script to check for failed logins)

# Binaries
Sed="/bin/sed"
Awk="/usr/bin/awk"
Egrep="/bin/egrep"
Mail="/usr/bin/mail"
Printf="/usr/bin/printf"

# Variables
Admin="jake"
Authlog="/var/log/auth.log"

# Sanity checks
if [ ! -r $Authlog ]; then
	echo "Can't read $Authlog"
	exit 1
fi

for Bin in $Sed $Awk $Egrep $Mail $Printf; do
	if [ ! -x $Bin ]; then
		echo "Can't execute $Bin"
		exit 1
	fi
done

# Main

# Print a nice header
$Printf "Date & time\t\tUser\t\tFrom host\n"
$Printf "-----------\t\t----\t\t---------\n"
# Search for failed logins
$Sed -n '1,$p' $Authlog | $Egrep "Failed password" | $Sed 's/invalid user//' | \
$Awk '{ print $1" "$2" "$3" \t"$9"\t\t"$11 }'

# Save the last line for next run (WORK IN PROGRESS)
cat /var/log/auth.log | sed -n '/Dec 28 20:40:41/{
=
p
}' | tail -n2 | sed -n '/^[0-9]/p' > /tmp/failed_login_last_line.tmp

exit 0
