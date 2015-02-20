.. _manual_config:

Manual configuration
====================

This section explains how main configuration file ``conf/config.yaml`` works as you would find
it more convenient than launching Install theme for each update.

Your ``conf/config.yaml`` file is built using YAML syntax. Each part match a Roadiz *service* configuration.
The most important part deals with Doctrine database credentials:

.. code-block:: yaml

    doctrine:
        driver: "pdo_mysql"
        host: "localhost"
        user: ""
        password: ""
        dbname: ""

Roadiz uses *Doctrine ORM* to store your data. It will directly pass this JSON part to *Doctrine* so
you can use every available drivers and options from its documentation at
http://doctrine-dbal.readthedocs.org/en/latest/reference/configuration.html

Dev mode
--------

When you’ll start using Roadiz, you’ll see a *dev mode* icon under your account picture.
Development mode is useful to build your theme or when you are setting up your
node-types and node-tree. In this mode, *Doctrine* empties its caches every time you load
a page and *Twig* templates are regenerated each time you update them. It’s very convenient
when your are working on your themes but it’s a lot more slower.

When you’ll switch to production mode, you must disable *devMode* so that database metadata
and *Twig* templates are requested from cache. It is even better if you have a *Var cache*
like *APC* or *XCache* since useful data are kept in memory. This efficiency has a drawback:
you’ll need to empty caches if you make a code update or a Roadiz update.

.. code-block:: yaml

    devMode: true

Another point about devMode is that static *Routes* are compiled at each request into a plain
PHP class (``gen-src/Compiled/…``). If you disable *devMode*, Symfony router will be a lot more efficient
and that’s the same for *UrlGenerator*


Solr endpoint
-------------

Roadiz can use an *Apache Solr* search-engine to index nodes-sources.
Add this to your `config.yaml` to link your CMS to your *Solr* server:

.. code-block:: yaml

    solr:
        endpoint:
            localhost:
                host: "localhost"
                port: "8983"
                path: "/solr"
                core: "mycore"
                timeout: 3
                username: ""
                password: ""

Roadiz CLI command can easily handle Solr index. Just type ``./bin/roadiz solr --help`` to get
more informations.


Entities paths
--------------

Roadiz uses *Doctrine* to map object entities to database tables.
In order to make Roadiz more extensible, you can add your own paths to the ``entities`` part.

.. code-block:: yaml

    entities:
        - "src/Roadiz/Core/Entities"
        - "src/Roadiz/Core/AbstractEntities"
        - "gen-src/GeneratedNodeSources"


Swift Mailer
------------

Roadiz uses *Swift Mailer* to send emails. This awesome librairy is built to enable different
kinds of mail transports or protocols. By default, Roadiz uses your PHP ``sendmail`` configuration
but you can tell it to use another transport (such as SMTP) in your ``conf/config.yaml`` file.

You can use *SSL*, *TLS* or no encryption at all.

.. code-block:: yaml

    mailer:
        type: "smtp"
        host: "localhost"
        port: 25
        encryption: false
        username: ""
        password: ""

Console command
---------------

Roadiz can be executed as a simple CLI tool using your SSH connection. This is useful to
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

CLI tools are useful to handle database upgrades and to regenerate nodes-sources entities classes.
But you also can switch *development mode* too:

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

