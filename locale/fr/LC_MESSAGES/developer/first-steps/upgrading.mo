��          |               �   �   �   M   i  �   �  s   �  b     O   z  	   �  N   �  m   #  `   �  S   �  �  F  �   �  M   ^  �   �  s   �  b   	  O   o	  	   �	  N   �	  m   
  `   �
  S   �
   **Always do a database backup before upgrading.** You can use the *mysqldump* or *pg_dump* tools to quickly export your database as a file. If you are using *Roadiz Source edition*: download latest version using *Git* If you are using an OPcode cache like XCache or APC, you’ll need to purge cache manually because it can't be done from a CLI interface as they are shared cache engines. As a last chance try, you can restart your ``php5-fpm`` service. In order to avoid losing sensible node-sources data. You should regenerate your node-source entities classes files: Then run database schema update, first review migration details to see if no data will be removed: Then, if migration summary is OK (no data loss), perform the following changes: Upgrading Use *Composer* to update dependencies or Roadiz itself with *Standard edition* With Roadiz command (MySQL only): ``bin/roadiz database:dump -c`` will generate a SQL file in ``app/`` folder With a MySQL server: ``mysqldump -u[user] -p[user_password] [database_name] > dumpfilename.sql`` With a PostgreSQL server: ``pg_dump -U [user] [database_name] -f dumpfilename.sql`` Project-Id-Version: Roadiz documentation 0.14.1
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2017-11-28 13:17+0100
PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE
Last-Translator: FULL NAME <EMAIL@ADDRESS>
Language: fr
Language-Team: fr <LL@li.org>
Plural-Forms: nplurals=2; plural=(n > 1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Generated-By: Babel 2.5.1
 **Always do a database backup before upgrading.** You can use the *mysqldump* or *pg_dump* tools to quickly export your database as a file. If you are using *Roadiz Source edition*: download latest version using *Git* If you are using an OPcode cache like XCache or APC, you’ll need to purge cache manually because it can't be done from a CLI interface as they are shared cache engines. As a last chance try, you can restart your ``php5-fpm`` service. In order to avoid losing sensible node-sources data. You should regenerate your node-source entities classes files: Then run database schema update, first review migration details to see if no data will be removed: Then, if migration summary is OK (no data loss), perform the following changes: Upgrading Use *Composer* to update dependencies or Roadiz itself with *Standard edition* With Roadiz command (MySQL only): ``bin/roadiz database:dump -c`` will generate a SQL file in ``app/`` folder With a MySQL server: ``mysqldump -u[user] -p[user_password] [database_name] > dumpfilename.sql`` With a PostgreSQL server: ``pg_dump -U [user] [database_name] -f dumpfilename.sql`` 