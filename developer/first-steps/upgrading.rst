.. _upgrading:

=========
Upgrading
=========

.. note::
    **Always do a database backup before upgrading.** You can use the *mysqldump* or *pg_dump* tools
    to quickly export your database as a file.

    * With a MySQL server: ``mysqldump -u[user] -p[user_password] [database_name] > dumpfilename.sql``
    * With a PostgreSQL server: ``pg_dump -U [user] [database_name] -f dumpfilename.sql``

If you are using *Roadiz Source edition*: download latest version using *Git*

.. code-block:: bash

    cd your/webroot/folder;
    git pull origin master;

Use *Composer* to update dependencies or Roadiz itself with *Standard edition*

.. code-block:: bash

    composer update -n --no-dev;

In order to avoid losing sensible node-sources data. You should
regenerate your node-source entities classes files:

.. code-block:: bash

    bin/roadiz generate:nsentities;

Then run database schema update, first review migration details
to see if no data will be removed:

.. code-block:: bash

    bin/roadiz orm:schema-tool:update --dump-sql;

Then, if migration summary is OK (no data loss), perform the following changes:

.. code-block:: bash

    bin/roadiz orm:schema-tool:update --force;
    # Clear cache for each environment
    bin/roadiz cache:clear -e dev
    bin/roadiz cache:clear -e prod
    bin/roadiz cache:clear -e prod --preview

.. note::
    If you are using an OPcode cache like XCache or APC, you’ll need to purge cache manually
    because it can't be done from a CLI interface as they are shared cache engines. As a last
    chance try, you can restart your ``php5-fpm`` service.

