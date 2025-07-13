#!/bin/bash

# Configura MySQL per partire correttamente in background e impostare password root
echo "Configurazione di MySQL..."

DATAMODEL="./datamodel/codeface_schema.sql"

# Inizializza il database (utile se non è già presente)
mysqld --initialize-insecure --user=mysql

# Abilita il servizio MySQL e imposta la password root
service mysql start

# Imposta la password per root ed eventualmente crea un database e un utente
mysql -u root <<EOF

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'codeface';
FLUSH PRIVILEGES;
CREATE DATABASE codeface;
CREATE DATABASE codeface_testing;

CREATE USER IF NOT EXISTS 'codeface'@'localhost' IDENTIFIED WITH mysql_native_password BY 'codeface';
GRANT ALL PRIVILEGES ON codeface.* TO 'codeface'@'localhost';
GRANT ALL PRIVILEGES ON codeface_testing.* TO 'codeface'@'localhost';
GRANT SUPER ON *.* TO 'codeface'@'localhost';

FLUSH PRIVILEGES;
EOF

set -e

mysql -u codeface -pcodeface < "$DATAMODEL"
if [ $? -ne 0 ]; then
  echo "ERROR: Failed to load codeface_schema.sql"
  exit 1
fi

cat "$DATAMODEL" | \
  sed -e 's/codeface/codeface_testing/g' | \
  mysql -u codeface -pcodeface

if [ $? -ne 0 ]; then
  echo "ERROR: Failed to import modified DATAMODEL"
  exit 1
fi

# Ferma MySQL, verrà riavviato dallo script di avvio del container
# service mysql stop