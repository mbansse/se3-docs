Installation d'un partage nfs pour effectuer des sauvegardes backuppc ou de VM proxmox

Pour faire des sauvegardes backuppc, par script

On dispose ici d'un disque de petite contenance sda pour installer le système (distrib debian serveur).
On a aussi deux disques sdb et sdc identiques. On va créer un raid1 (mirroring) logiciel entre sdb et sdc. Ce raid sera monté ensuite dans le système. Les disques sont des disques sata, aucune carte raid n'est nécessaire puisqu'il s'agit d'un raid logiciel et donc géré par Débian.

# installation de la debian de base
* On boot avec un livecd netinstall debian stretch (https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.4.0-amd64-netinst.iso)
* On choisit le mode avancé (pas graphical install qui est inutile pour un serveur)
* On choisi le nom, mos de passe root et utilisateurs.
* On va partitionner le disque sda (1.png) choisir "mode assisté, utiliser un disque entier". Valider
* On va aussi créer une partition sdb1 (et sdc1 si on veut faire un raid logiciel plus tard). On clique sur sdb et on valide pour faire une partition utilisant le disque entier.
Ainsi sdb1 (et sdc1 sont créées). 2.png

* Lire un autre cd :non

* Choix du miroir
On peut utiliser celui du se3 (apt-cacher). On montra jusqu'à choisir "manuel"
Nom d'hote du miroir de l'archive debian: http://172.20.0.2:9999 
On valide puis on entre /ftp.fr.debian.org/debian/

* Choix du proxy: on entre celui de l'Amon (http://172.20.0.1:3128)
* Choix des logiciels à installer: seulement serveur ssh et utilitaires usuels du système.
* Installer le grub sur le disque sda (ainsi, pas de problème en cas de changement de config du raid).
* on redémarre.
On réservera une ip pour le serveur.

# Création du raid1 logiciel.
* On installe le paquet mdadm
```
apt-get install mdadm
```
* On indique que les partitions sdb1 et sdc1 vont servir pour le raid1
```
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

Le raid est maintenant créé sous le device md127.
```
mdadm --examine --scan --verbose >> /etc/mdadm/mdadm.conf
update-initramfs -u -k all

```
On redémarre le serveur pour que le raid soit bien sous le bon nom /dev/md0 (il peut apparaitre sous le nom /dev/md126 ou md127) .
Un lsblk permet de vérifier que sdb et sdc sont bien dans md0.

Il faut maintenant le formater .
```
mkfs.ext4 /dev/md0
```

# Montage du raid
```
mkdir /home/partage-nfs

nano /etc/fstab
```
On ajoute les lignes relatives au montage du raid
```
/dev/md0      /mhome/partage-nfs     ext4      defaults      0      2
```
On lance ensuite
```
mount -a
```
Normalement la commande lsblk doit donner une arborescence de ce genre:

```
NAME   MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda      8:0    0    20G  0 disk
├─sda1   8:1    0    19G  0 part  /
├─sda2   8:2    0     1K  0 part
└─sda5   8:5    0  1022M  0 part  [SWAP]
sdb      8:16   0 100,6G  0 disk
└─md0    9:0    0 100,6G  0 raid1 /home/partage-nfs
sdc      8:32   0 100,6G  0 disk
└─md0    9:0    0 100,6G  0 raid1 /home/partage-nfs
sr0     11:0    1  1024M  0 rom
```

# Création du partage nfs










