# Scripts
My useful scripts

wifirestart.sh and hibernate.sh should be combined with modified sudoers file according to the following: 

username ALL=(ALL) NOPASSWD: /usr/sbin/pm-hibernate

username ALL=(ALL) NOPASSWD: /home/username/PathToScriptsFolder/wifirestart.sh
