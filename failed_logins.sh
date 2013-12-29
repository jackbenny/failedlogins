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
Cat="/bin/cat"
Grep="/bin/grep"
Mktemp="/bin/mktemp"
Rm="/bin/rm"
Tail="/usr/bin/tail"

# Variables
Admin="jake"
Authlog="/var/log/auth.log"
StampTemp="/tmp/failed_login_last_stamp.tmp"
LineTemp="/tmp/failed_login_last_line.tmp"
StartLine=1 # Don't change this!
New=0 #Don't change this!

# Functions
check_for_new_failed()
{
	$Sed -n "$StartLine,\$p" $Authlog | $Egrep "Failed password" \
		&> /dev/null
	if [ $? -eq 0 ]; then
		New=1
	fi	
}

show_failed_logins()
{
	$Sed -n "$StartLine,\$p" $Authlog | $Egrep "Failed password" | \
	$Sed 's/invalid user//' | \
	$Awk '{ print $1" "$2" "$3" \t"$9"\t\t"$11 }'
}

save_last_stamp_and_line()
{
	show_failed_logins | $Awk '{ print $1" "$2" "$3 }' \
		| $Sed -n '$p' > $StampTemp
	LastStamp=`$Cat $StampTemp`

	$Cat $Authlog | $Sed -n "/$LastStamp/{
	=
	p
	}" | $Tail -n2 | $Sed -n '/^[0-9]/p' > $LineTemp
}

# Sanity checks
if [ ! -r $Authlog ]; then
	echo "Can't read $Authlog"
	exit 1
fi

for Bin in $Sed $Awk $Egrep $Mail $Printfi $Cat $Grep $Mktemp $Rm $Tail; do
	if [ ! -x $Bin ]; then
		echo "Can't execute $Bin"
		exit 1
	fi
done

if [ -e $StampTemp ] || [ -e $LineTemp ]; then
	if [ ! -w $StampTemp ] || [ ! -w $LineTemp ] ; then
		$Printf "Can't write to temp files, perhaps this script "
		$Printf "has been run be a different user before?\n"
		$Printf "Consider changing the temp filenames variable\n"
		exit 1
	fi
fi

if [ ! -w /tmp ]; then
	echo "Can't write to /tmp"
	exit 1
fi

### Main ###

# First of all, check if we have read the log file before and whatever if has
# been rotated
if [ -e $StampTemp ] && [ -e $LineTemp ]; then
	$Sed -n "`$Cat $LineTemp`p" $Authlog | $Grep "`$Cat $StampTemp`" \
		> /dev/null
	if [ $? -eq 0 ]; then                # If the logfile hasn't been 
		StartLine=`$Cat $LineTemp`   # been rotated, set StartLine
		((StartLine++))              # from the last run and +1
	fi
fi

# Check for new failed login attempts since last run (based on StartLine)
check_for_new_failed

# Redirect all output below to a temporary file for mailing
MailTemp=`$Mktemp -t failed_logins_mail.XXXXXX`
exec 1> $MailTemp

if [ $New -eq 1 ]; then # = if there are new failed logins
	# Print a nice header
	$Printf "Date & time\t\tUser\t\tFrom host\n"
	$Printf "-----------\t\t----\t\t---------\n"

	# Print out the latest failed login attempts
	show_failed_logins

	# Save the last line and the last timestamp for the next run
	save_last_stamp_and_line
fi

# Mail the failed logins if there are any (ie if the MailTemp file is NOT empty)
if [ -s $MailTemp ]; then
	$Mail $Admin -s "Failed logins" < $MailTemp
fi

# Clean up
if [ -e $MailTemp ]; then
	$Rm $MailTemp
fi

exit 0
