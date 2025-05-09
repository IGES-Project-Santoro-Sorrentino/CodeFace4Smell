#!/bin/sh

echo "Providing codeface database"

mysql -e "CREATE DATABASE codeface;" -uroot
mysql -e "CREATE DATABASE codeface_testing;" -uroot
mysql -e "CREATE USER 'codeface'@'localhost' IDENTIFIED BY 'codeface';" -uroot
mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'codeface'@'localhost';" -uroot

DATAMODEL="datamodel/codeface_schema.sql"
mysql -ucodeface -pcodeface < ${DATAMODEL}
cat ${DATAMODEL} | sed -e 's/codeface/codeface_testing/g' | mysql -ucodeface -pcodeface