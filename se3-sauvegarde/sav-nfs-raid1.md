Installation d'un partage nfs pour effectuer des sauvegardes backuppc ou de VM proxmox

On dispose ici d'un disque de petite contenance sda pour installer le système (distrib debian serveur).
On a aussi deux disques sdb et sdc identiques. On va créer un raid logiciel entre sdb et sdc. Ce raid sera monté ensuite dans le système.

installation de la debian de base
On choisi le nom, mos de passe root et utilisateurs.
On va partitionner le disque sda (1.png) choisir "mode assisté, utiliser un disque entier". Valider
On ne s'occupe pas pour l'instant des deux autres disques.
Lire un autre cd >non

* Choix du miroir
On peut utiliser celui du se3 (apt-cacher). On montra jusqu'à choisir "manuel"
Nom d'hote du miroir de l'archive debian: http://172.20.0.2:9999 
On valide puis on entre /ftp.fr.debian.org/debian/

* Choix du proxy: on entre celui de l'Amon (http://172.20.0.1:3128)
* Choix des logiciels à installer: seulement serveur ssh et utilitaires usuels du système.






