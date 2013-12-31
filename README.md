# failedlogins #
This is a small Bash script I wrote for a programming & scripting class at
school. The script (failedlogins.sh) checks for failed SSH logins in 
/var/log/auth.log by default.
The failed logins are then sent by e-mail to the admin user specified in the
Admin variable.
The script only mails new failed login attempts since it was last run to avoid 
cluttering the admin's mailbox.

## Usage ##
The script is meant to run from a cronjob, for example once every hour or day
or whatever suits your needs. An example (15 minutes after every hour) would be:
```
15 * * * * /home/admin/failedlogins.sh
```

## Compability ##
So far I've only tested it on Ubuntu 13.04. The binaries used in the script are
hardcoded to avoid unsane environments. The path to these binaries
could change on other Linux dists and other *NIX.
For this purpose I've created a small configuration script that updates all the
binaries to match the current system it's being run on. Since the configuration
script is meant to run directly by a user and not in a cronjob there are no
hardcoded binaries in this script. Simply run `./configure.sh` in this
directory in case failedlogins.sh complains about some binaries.

failedlogins.sh uses sed, awk (standrad awk), egrep, cat, printf, mail, rm, tail,
mktemp and regular grep. All of these utilities are pretty standard on a 
Debian/Ubuntu machine, except for mail which is not included in for example 
Ubuntu Desktop. On both Ubuntu and Debian this can be installed with 
`sudo apt-get install mailutils`. (Which will also install Postfix if it's not
already installed).

## Flowchart and notes ##
These files can be ignored, they are included for the sake of the scripting
class and for my own reference.
