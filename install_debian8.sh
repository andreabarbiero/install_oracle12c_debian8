#!/bin/bash

################################################################
#                                                              #
#    Author: Andrea Barbiero <andrea.barbiero1@gmail.com>      #
#                                                              #
################################################################

#########################################################################################################################
#                                  IMPORTANTE PER IL CORRETTO FUNZIONAMENTO!                                            #
#                                                                                                                       #
# DAL VOSTRO TERMINALE ANDATE NEL PATH DOVE È PRESENTE IL FILE linuxx64_12201_database.zip E LANCIATE IL COMANDO        #
# SEGUENTE python3 -m http.server QUESTO COMANDO GENERA UN SERVER HTTP IN ASCOLTO ALL'INDIRIZZO http://localhost:8080/  #
# A QUESTO PUNTO IL COMANDO wget http://ip_del_vostro_pc:8080/linuxx64_12201_database.zip ALLA RIGA 82 SARÀ IN GRADO DI        #
# SCARICARE IL PROGRAMMA.                                                                                               #
#                                                                                                                       #
######################################################################################################################### 


# Commento il link al repository del CDROM di installazione
sed -i 's/deb cdrom:/#deb cdrom:/g' /etc/apt/sources.list

# Aggiungo i repository necessari per scaricare i pacchetti ed alcue librerie
echo 'deb http://deb.debian.org/debian jessie main contrib non-free' >> /etc/apt/sources.list
echo 'deb-src http://deb.debian.org/debian jessie main contrib non-free' >> /etc/apt/sources.list
echo 'deb http://cz.archive.ubuntu.com/ubuntu bionic machine' >> /etc/apt/sources.list

# Aggiorno il repository
apt-get update

# Installo i pacchetti necessari e le librerie
apt-get install gcc make binutils libmotif4 rpm libaio1 libdb4.6 libstdc++5 unzip -y

# Creo i collegamenti simbolici necessari
ln -s /usr/bin/awk /bin/awk
ln -s /usr/bin/rpm /bin/rpm
ln -s /usr/bin/basename /bin/basename
ln -s /etc /etc/rc.d
ln -s /usr/lib/x86_64-linux-gnu /usr/lib64

# Creo l'utente Oracle con password "oracle" (in modo non interattivo) ed i gruppi dba e oinstall, poi aggiungo l'utente oracle a tutti e due i gruppi
groupadd oinstall
groupadd dba
useradd -m -g oinstall -G dba -p passwd -s /bin/bash -d /home/oracle oracle
echo "oracle:oracle" | chpasswd

# Aggiungo i seguenti parametri in /etc/sysctl.conf
echo 'kernel.sem = 250 32000 100 128' >> /etc/sysctl.conf
echo 'kernel.shmmax = 8589934592 #8GB' >> /etc/sysctl.conf
echo 'net.core.rmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.rmem_max = 4194304' >> /etc/sysctl.conf
echo 'net.core.wmem_default = 262144' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 1048576' >> /etc/sysctl.conf
echo 'fs.aio-max-nr = 1048576' >> /etc/sysctl.conf
echo 'fs.file-max = 6815744' >> /etc/sysctl.conf
echo 'vm.hugetlb_shm_group = 1001' >> /etc/sysctl.conf

# Modifico il file /etc/security/limits.conf aggiungendo i seguenti parametri:
echo '*        soft    nproc   2047' >> /etc/security/limits.conf
echo '*        hard    nproc   16384' >> /etc/security/limits.conf
echo '*        soft    nofile  1024' >> /etc/security/limits.conf
echo '*        hard    nofile  65536' >> /etc/security/limits.conf

# Aggiungo quanto segue ad /etc/profile:
cat <<EOT >> /etc/profile
if [ $USER = "oracle" ]; then
  if [ $SHELL = "/bin/ksh" ]; then
    ulimit -p 16384
    ulimit -n 65536
  else
    ulimit -u 16384 -n 65536
  fi
fi
EOT


# Creo i path per l'installazione
mkdir /u01

# Assegno l'utente oracle come proprietario del path e come gruppo oinstall in modo recursivo tramite -R
chown -R oracle:oinstall /u01/

# Mi sposto nel path /home/oracle
cd /home/oracle/

# Scarico il pacchetto di installazione nella directory /home/oracle
wget http://ip_del_vostro_pc:8080/linuxx64_12201_database.zip

# Assegno l'utente oracle come proprietario del file e come gruppo oinstall
chown -R oracle:oinstall /home/oracle/linuxx64_12201_database.zip

# Estraggo il contenuto del file .zip
unzip linuxx64_12201_database.zip

# Assegno l'utente oracle come proprietario del path e come gruppo oinstall in modo tale che anche i file estratti hanno i stessi permessi
chown -R oracle:oinstall /home/oracle/

# Scrivo le variabili d'ambiente per iniziare l'installazione
cat <<EOT >> /home/oracle/.profile
export ORACLE_BASE=/u01/app/oracle
unset ORACLE_HOME
unset TNS_ADMIN
EOT

# Modifico tramite sed il file con i parametri per l'installazione
sed -i 's/oracle.install.option=/oracle.install.option=INSTALL_DB_SWONLY/g' /home/oracle/database/response/db_install.rsp
sed -i 's/UNIX_GROUP_NAME=/UNIX_GROUP_NAME=oinstall/g' /home/oracle/database/response/db_install.rsp
sed -i 's|INVENTORY_LOCATION=|INVENTORY_LOCATION=/u01/app/oraInventory|g' /home/oracle/database/response/db_install.rsp
sed -i 's|ORACLE_HOME=|ORACLE_HOME=/u01/app/oracle/product/12.2.0/dbhome_1|g' /home/oracle/database/response/db_install.rsp
sed -i 's|ORACLE_BASE=|ORACLE_BASE=/u01/app/oracle/product|g' /home/oracle/database/response/db_install.rsp
sed -i 's/oracle.install.db.InstallEdition=/oracle.install.db.InstallEdition=EE/g' /home/oracle/database/response/db_install.rsp
sed -i 's/oracle.install.db.OSDBA_GROUP=/oracle.install.db.OSDBA_GROUP=oinstall/g' /home/oracle/database/response/db_install.rsp
sed -i 's/oracle.install.db.OSOPER_GROUP=/oracle.install.db.OSOPER_GROUP=oinstall/g' /home/oracle/database/response/db_install.rsp
sed -i 's/oracle.install.db.OSBACKUPDBA_GROUP=/oracle.install.db.OSBACKUPDBA_GROUP=oinstall/g' /home/oracle/database/response/db_install.rsp
sed -i 's/oracle.install.db.OSDGDBA_GROUP=/oracle.install.db.OSDGDBA_GROUP=oinstall/g' /home/oracle/database/response/db_install.rsp
sed -i 's/oracle.install.db.OSKMDBA_GROUP=/oracle.install.db.OSKMDBA_GROUP=oinstall/g' /home/oracle/database/response/db_install.rsp
sed -i 's/oracle.install.db.OSRACDBA_GROUP=/oracle.install.db.OSRACDBA_GROUP=oinstall/g' /home/oracle/database/response/db_install.rsp
sed -i 's/SECURITY_UPDATES_VIA_MYORACLESUPPORT=/SECURITY_UPDATES_VIA_MYORACLESUPPORT=false/g' /home/oracle/database/response/db_install.rsp
sed -i 's/DECLINE_SECURITY_UPDATES=/DECLINE_SECURITY_UPDATES=true/g' /home/oracle/database/response/db_install.rsp

# Da utente Oracle lancio l'installazione
su - oracle<<EOF
./database/runInstaller -silent -responseFile /home/oracle/database/response/db_install.rsp -ignoreSysPrereqs -showProgress
sleep 3m
exit
EOF

# Eseguo gli script indicati durante l'installazione di oracle12c
/u01/app/oraInventory/orainstRoot.sh
/u01/app/oracle/product/12.2.0/dbhome_1/root.sh

# Imposto le variabili d'ambiente definitive per l'utente oracle
sed -i 's|unset ORACLE_HOME|export ORACLE_HOME=$ORACLE_BASE/product/12.2.0/dbhome_1|g' /home/oracle/.profile
sed -i 's/unset TNS_ADMIN//g' /home/oracle/.profile
cat <<EOT >> /home/oracle/.profile
export ORACLE_SID=ORCL
export ORATAB=/etc/oratab
export NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1
export TZ=Europe/Rome
export sysPass=oracle123
export systemPass=oracle123
unset TNS_ADMIN
export PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/u01/app/oracle/product/12.2.0/dbhome_1/bin
EOT

# Lancio il comando per la creazione del database
runuser -l oracle -c 'dbca -silent -createDatabase -templateName General_Purpose.dbc -gdbName ${ORACLE_SID} -sid ${ORACLE_SID} -createAsContainerDatabase false -emConfiguration NONE -sysPassword ${sysPass} -systemPassword ${systemPass} -datafileDestination /u01/app/oradata -storageType FS -characterSet AL32UTF8 -totalMemory 2048 -recoveryAreaDestination /u01/FRA -sampleSchema true'

# Avvio il listner 
runuser -l oracle -c 'lsnrctl start'

# Verifico che la connessione al DB è avvenuta con successo
runuser -l oracle -c 'sqlplus /nolog<<EOF
connect /as sysdba'

# Elimino le password per SYS e SYSTEM dalle variabili d'ambiente
sed -i 's|export sysPass=oracle123||g' /home/oracle/.profile
sed -i 's|export systemPass=oracle123||g' /home/oracle/.profile

# Quando il programma di installazione termina dobbiamo attendere circa 1/2 minuti per connetterci con un client al db, perchè Oracle stà avviando l'istanza
echo 'Ci siamo quasi...'
sleep 2m

echo 'Ok, ora puoi provare a connetterti al DB'


