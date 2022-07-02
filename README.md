# install_oracle12c_debian8
script per automatizzare l'installazione di Oracle 12c  nella modalità silente

# Pre-requisiti
# Nel file /etc/hosts deve essere settato l'indirizzo ip assegnato al server come nell'esempio di seguito

root@oracle12c:~# cat /etc/hosts

127.0.0.1	localhost

192.168.1.195	oracle12c.localdomain	oracle12c

#The following lines are desirable for IPv6 capable hosts

::1     localhost ip6-localhost ip6-loopback

ff02::1 ip6-allnodes

ff02::2 ip6-allrouters

# Verificare che la versione del S.O. e del Kernel siano le seguenti
root@oracle12c:~# uname -a

Linux oracle12c 3.16.0-6-amd64 #1 SMP Debian 3.16.56-1+deb8u1 (2018-05-08) x86_64 GNU/Linux

# A questo punto potete copiare il file install_debain8.sh nella nella cartella /root ed eseguire i comandi seguenti come utente root

chmod +x install_debain8.sh

./install_debain8.sh

NOTA: il file .zip che contiene i file di installazione viene scaricato tramite wget da un link esterno, qual'ora il link non fosse disponibile lo script non funzionerà. Consiglio di scaricare in locale lo zip dal link http://35.233.92.209/linuxx64_12201_database.zip e di consequenza modificare lo script.
