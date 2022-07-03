# install_oracle12c_debian8
script per automatizzare l'installazione di Oracle 12c  nella modalità silente

# Pre-requisiti
Essere in possesso del file linuxx64_12201_database.zip

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

# Nel file install_debian8.sh dovete impostare il vostro indirizzo ip nella variabile ip e salvare il file.

# A questo punto potete copiare il file install_debain8.sh nella cartella /root ed eseguire i comandi seguenti come utente root

chmod +x install_debain8.sh

./install_debain8.sh

NOTA: PER RENDERE LO SCRIPT COMPLETAMENTE AUTOMATICO, POTETE ATTIVARE UN SERVER HTTP LOCALE NEL QUALE DEPOSITATE IL FILE linuxx64_12201_database.zip,
E NELLO SCRIPT AGGIUNGERE ALLA RIGA 82 IL COMANDO wget http://ip_del_vostro_web_server/linuxx64_12201_database.zip IN QUESTO MODO NON DOVRETE ACCEDERE ALL'HOST PER COPIARE IL FILE MANUALMENTE.

--------------------------------------------------------------------------------------------------------------------------------------

# CONNETTERSI AL DATABASE

Host: indirizzo ip del server Oracle 12c

Porta: 1521

Database: ORCL

utente: system

password: oracle123


