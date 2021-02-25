.. _upgrading:

=========
Upgrading
=========

.. note::
    **Always do a database backup before upgrading.** You can use the *mysqldump* or *pg_dump* tools
    to quickly export your database as a file.

    * With Roadiz command (MySQL/MariaDB only): ``bin/roadiz database:dump -c`` will generate a SQL file in ``app/`` folder
    * With a MySQL server: ``mysqldump -u[user] -p[user_password] [database_name] > dumpfilename.sql``
    * With a PostgreSQL server: ``pg_dump -U [user] [database_name] -f dumpfilename.sql``


Use *Composer* to update dependencies or Roadiz itself with *Standard* or *Headless* editions, make sure that
your Roadiz *version constraint* is set in your project ``composer.json`` file, then:

.. code-block:: bash

    composer update -o;

Run database registered migrations (some migrations will be skipped according to your database type). Doctrine
migrations are the default method to upgrade all none-node-type related entities:

.. code-block:: bash

    bin/roadiz migrations:migrate;

In order to avoid losing sensible node-sources data. You should
regenerate your node-source entities classes files:

.. code-block:: bash

    bin/roadiz generate:nsentities;

Then check if there is no pending SQL changes due to your Roadiz node-types:

.. code-block:: bash

    bin/roadiz orm:schema-tool:update --dump-sql;
    # Upgrade node-sources tables if necessary
    bin/roadiz orm:schema-tool:update --dump-sql --force;

Then, clear your app caches:

.. code-block:: bash

    # Clear cache for each environment
    bin/roadiz cache:clear -e dev
    bin/roadiz cache:clear -e prod
    bin/roadiz cache:clear -e prod --preview
    bin/roadiz cache:clear-fpm -e dev
    bin/roadiz cache:clear-fpm -e prod
    bin/roadiz cache:clear-fpm -e prod --preview

.. note::
    If you are using a runtime cache like OPcache or APCu, you’ll need to purge cache manually
    because it can't be done from a CLI interface as they are shared cache engines. As a last
    chance try, you can restart your ``php-fpm`` service.

