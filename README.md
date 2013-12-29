# failed\_logins.sh #
This is a small Bash script I wrote for a programming & scripting course at
school. The script checks for failed SSH logins in /var/log/auth.log by default.
The failed logins are then sent by e-mail to the admin user specified in the
Admin variable.
The script only mails new failed login attempts since it was last run to avoid 
cluttering the admin's mailbox.

## Usage ##
The script is meant to run from a cronjob, for example once every hour or day
or whatever suits your needs. An example (15 minutes after every hour) would be:
```
15 * * * * /home/admin/failed_logins.sh
```

## Compability ##
So far I've only tested it on Ubuntu 13.04. The binaries used in the script are
hardcoded to avoid unsane environments. The path to these hardcoded binaries
could change on other Linux dists and other *NIX.

The script uses sed, awk (standrad awk), egrep, cat, printf, mail, rm, tail,
mktemp and regular grep. All of these utilities are pretty standard on a 
Debian/Ubuntu machine, except for mail which is not included in for example 
Ubuntu Desktop. On both Ubuntu and Debian this can be installed with 
`sudo apt-get install mailutils`.


