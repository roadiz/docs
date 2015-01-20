.. _upgrading:

=========
Upgrading
=========

.. note::
    **Always do a database backup before upgrading.** You can use the *mysqldump* or *pg_dump* tools
    to quickly export your database as a file.

    * With a MySQL server: ``mysqldump -u [user] -p[user_password] [database_name] > dumpfilename.sql``
    * With a PostgreSQL server: ``pg_dump -U [user] [database_name] -f dumpfilename.sql``

Download latest version using *Git*

.. code-block:: bash

    cd your/webroot/folder;
    git pull origin master;

Use *Composer* to update dependancies

.. code-block:: bash

    composer update -n --no-dev;

In order to avoid losing sensible node-sources data. You should
regenerate your node-types entities files:

.. code-block:: bash

    bin/roadiz core:node-types --regenerateAllEntities;

Then run database schema update, first review migration details
to see if no data will be removed:

.. code-block:: bash

    bin/roadiz orm:schema-tool:update --dump-sql;

Then, if migration summary is OK (no data loss), perform the changes:

.. code-block:: bash

    bin/roadiz orm:schema-tool:update --force;
    bin/roadiz cache --clear-all

.. note::
    If you are using an OPcode cache like XCache or APC, you’ll need to purge cache manually
    because it cannot done from a CLI interface as they are shared cache engines. As a last
    chance try, you can restart your ``php5-fpm`` service.

