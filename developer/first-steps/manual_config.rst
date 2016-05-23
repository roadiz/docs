.. _manual_config:

Manual configuration
====================

This section explains how main configuration file ``conf/config.yml`` works.
It is way more more convenient than launching Install theme for each update.

Your ``conf/config.yml`` file is built using YAML syntax. Each part matches a Roadiz *service* configuration.
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

Solr endpoint
-------------

Roadiz can use an *Apache Solr* search-engine to index nodes-sources.
Add this to your `config.yml` to link your CMS to your *Solr* server:

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

Roadiz CLI command can easily handle Solr index. Just type ``./bin/roadiz solr:check`` to get
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


Configure mailer
----------------

Roadiz uses *Swift Mailer* to send emails. This awesome librairy is built to enable different
kinds of mail transports or protocols. By default, Roadiz uses your PHP ``sendmail`` configuration
but you can tell it to use another transport (such as SMTP) in your ``conf/config.yml`` file.

You can use *SSL*, *TLS* or no encryption at all.

.. code-block:: yaml

    mailer:
        type: "smtp"
        host: "localhost"
        port: 25
        encryption: false
        username: ""
        password: ""

Images processing
-----------------

Roadiz use `Image Intervention <http://image.intervention.io/>`_ library to automatically create a lower quality
version of your image if they are too big. You can define this threshold value
in the `assetsProcessing` section. `driver` and `defaultQuality` will be also
use for the on-the-fly image processing with `Intervention Request <https://github.com/ambroisemaupate/intervention-request>`_ library.

.. code-block:: yaml

    assetsProcessing:
        # gd or imagick (gd does not support TIFF and PSD formats)
        driver: gd
        defaultQuality: 90
        # pixel size limit () after roadiz
        # should create a smaller copy.
        maxPixelSize: 1280


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


We even made *Doctrine* CLI tools directly available from Roadiz Console. Be careful, these are powerful
commands which can alter your database and make you lose precious datas. Especially when you will need to update
your database schema after a Theme or a Core update. **Always make a database back-up before any Doctrine operation**.

