#!/bin/bash

#Script d'installation du paquet fail2ban pour sécuriser l'interface
# 3 erreurs de connexion
apt-get install -y fail2ban

#On remplace le fichier /usr/share/fail2ban/server/datedetector.py par une version patchée qui détectera bien la date dans les logs du se3.
cd /usr/share/fail2ban/server/
mv /usr/share/fail2ban/server/datedetector.py  /usr/share/fail2ban/server/datedetector.py.sav
wget https://raw.githubusercontent.com/SambaEdu/se3master/master/usr/share/fail2ban/server/datedetector.py



#On ajoute un fichier jail.local qui va indiquer à fail2ban de regarder les logs du se3 pour détecter de multiples erreurs de connexion
cd /etc/fail2ban/
wget https://raw.githubusercontent.com/SambaEdu/se3master/master/etc/fail2ban/jail.local
cd  /etc/fail2ban/filter.d/
wget https://raw.githubusercontent.com/SambaEdu/se3master/master/etc/fail2ban/filter.d/interface-se3.conf


#changement de fichier de configuration

service fail2ban restart
echo "Pensez à modifier le fichier /etc/fail2ban/jail.conf pour y mettre votre email dans la variable "destemail = root@localhost""
exit
