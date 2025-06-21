#!/bin/bash

# Configura MySQL per partire correttamente in background e impostare password root
echo "Configurazione di MySQL..."

# Inizializza il database (utile se non è già presente)
mysqld --initialize-insecure --user=mysql

# Abilita il servizio MySQL e imposta la password root
service mysql start

# Imposta la password per root ed eventualmente crea un database e un utente
mysql -u root <<EOF

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'codeface';
FLUSH PRIVILEGES;
CREATE DATABASE codeface;

CREATE USER IF NOT EXISTS 'codeface'@'localhost' IDENTIFIED WITH mysql_native_password BY 'codeface';
GRANT ALL PRIVILEGES ON codeface.* TO 'codeface'@'localhost';
GRANT SUPER ON *.* TO 'codeface'@'localhost';

FLUSH PRIVILEGES;
EOF

mysql -u root -pcodeface codeface < /codeface_schema.sql

# Ferma MySQL, verrà riavviato dallo script di avvio del container
service mysql stop