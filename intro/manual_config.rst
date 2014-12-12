.. _manual_config:

Manual configuration
====================

This section explains how main configuration file ``conf/config.json`` works as you would find
it more convenient than launching Install theme for each update.

Your ``conf/config.json`` file is built using JSON syntax. Each part match a Roadiz *service* configuration.
The most important part deals with Doctrine database credentials:

.. code-block:: json

    "doctrine": {
        "driver": "pdo_mysql",
        "host": "localhost",
        "user": "",
        "password": "",
        "dbname": ""
    }

Roadiz uses *Doctrine ORM* to store your data. It will directly pass this JSON part to *Doctrine* so
you can use every available drivers and options from its documentation at
http://doctrine-dbal.readthedocs.org/en/latest/reference/configuration.html


Solr endpoint
-------------

Roadiz can use an *Apache Solr* search-engine to index nodes-sources.
Add this to your `config.json` to link your CMS to your *Solr* server:

.. code-block:: json

    "solr": {
        "endpoint": {
            "localhost": {
                "host":"localhost",
                "port":"8983",
                "path":"/solr",
                "core":"mycore",
                "timeout":3,
                "username":"",
                "password":""
            }
        }
    }

Roadiz CLI command can easily handle Solr index. Just type ``./bin/roadiz solr --help`` to get
more informations.


Entities paths
--------------

Roadiz uses *Doctrine* to map object entities to database tables.
In order to make Roadiz more extensible, you can add your own paths to the ``entities`` part.

.. code-block:: json

    "entities": [
        "src/Roadiz/Core/Entities",
        "src/Roadiz/Core/AbstractEntities",
        "gen-src/GeneratedNodeSources"
    ]

Console command
---------------

Roadiz can be executed as a simple CLI tool using your SSH connexion. This is useful to
handle basic administration tasks with no need of backoffice administration.

.. code-block:: console

    ./bin/roadiz

If your system is not configured to have *php* located in ``/usr/bin/php`` use it this way:

.. code-block:: console

    php ./bin/roadiz

Default command with no arguments will show you the available commands list. Each command has its
own parameters. You can use the argument ``--help`` to get more informations about each tool:

.. code-block:: console

    ./bin/roadiz install --help

As you already saw in :ref:`upgrading` section, CLI tools are useful to handle database upgrades and
to regenerate nodes-sources entities classes. But you also can switch *development mode* too:

.. code-block:: console

    # Enabling development mode
    ./bin/roadiz config --enable-devmode

    # Disabling development mode
    ./bin/roadiz config --disable-devmode

You can even review every user roles:

.. code-block:: console

    ./bin/roadiz users

We even made *Doctrine* CLI tools directly available from Roadiz Console. Be careful, these are powerful
commands which can alter your database and make you lose precious contents. Especially when you will need to update
your database schema after a Theme or a Core update. **Always make a database back-up before any Doctrine operation**.

