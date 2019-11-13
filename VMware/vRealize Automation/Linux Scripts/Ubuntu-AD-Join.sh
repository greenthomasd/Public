echo Hello World > /home/uams/helloworld.txt

echo 'Adjo1n$@cct' | realm join AD.UAMS.EDU --user=ADJoinSVC --install=/

realm permit -g "System Admins"
realm permit -g "Linux Admins"

sed -i 's/pam/pam, ssh/' /etc/sssd/sssd.conf

systemctl restart sssd