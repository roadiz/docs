.. _upgrading:

=========
Upgrading
=========

.. note::
    **Always do a database backup before upgrading.** You can use the *mysqldump* or *pg_dump* tools
    to quickly export your database as a file.

    * With a MySQL server: ``mysqldump -u[user] -p[user_password] [database_name] > dumpfilename.sql``
    * With a PostgreSQL server: ``pg_dump -U [user] [database_name] -f dumpfilename.sql``


Use *Composer* to update dependencies or Roadiz itself with *Standard* or *Headless* editions, make sure that
your Roadiz *version constraint* is set in your project ``composer.json`` file, then:

.. code-block:: bash

    composer update -o;

Run database registered migrations (some migrations will be skipped according to your database type). Doctrine
migrations are the default method to upgrade all none-node-type related entities:

.. code-block:: bash

    bin/console doctrine:migrations:migrate;

In order to avoid losing sensible node-sources data. You should
regenerate your node-source entities classes files:

.. code-block:: bash

    bin/console generate:nsentities;

Then check if there is no pending SQL changes due to your Roadiz node-types:

.. code-block:: bash

    bin/console doctrine:schema:update --dump-sql;
    # Upgrade node-sources tables if necessary
    bin/console doctrine:schema:update --dump-sql --force;

Then, clear your app caches:

.. code-block:: bash

    # Clear cache for each environment
    bin/console cache:clear -e dev
    bin/console cache:clear -e prod

.. note::
    If you are using a runtime cache like OPcache or APCu, you’ll need to purge cache manually
    because it can't be done from a CLI interface as they are shared cache engines. As a last
    chance try, you can restart your ``php-fpm`` service.

