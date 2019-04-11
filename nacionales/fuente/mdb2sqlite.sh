#!/bin/bash
# Inspired by 
# https://www.codeenigma.com/community/blog/using-mdbtools-nix-convert-microsoft-access-mysql

# USO
# Renombrar el archivo de base de datos con extensión de esta manera: migration-export.mdb 
# Correr el siguiente comando:  ./mdb2sqlite.sh migration-export.mdb
# Esperar... y esperar un rato más... y un poco más... 

mdb-schema migration-export.mdb sqlite > schema.sql
mkdir sqlite
mkdir sql
for i in $( mdb-tables migration-export.mdb ); do echo $i ; mdb-export -D "%Y-%m-%d %H:%M:%S" -H -I sqlite migration-export.mdb $i > sql/$i.sql; done

mv schema.sql sqlite
mv sql sqlite
cd sqlite

cat schema.sql | sqlite3 db.sqlite3

for f in sql/* ; do echo $f && cat $f | sqlite3 db.sqlite3; done
