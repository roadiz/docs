.. _manual_config:

Manual configuration
====================

This section explains how main configuration file ``app/conf/config.yml`` works.
It is way more more convenient than launching Install theme for each configuration update.

Your ``app/conf/config.yml`` file is built using YAML syntax. Each part matches a Roadiz *service* configuration.

.. note::
    By default, every Roadiz environment read ``app/conf/config.yml`` configuration file. But you can specify different
    files for ``dev`` and ``test`` environments. Just create a ``app/conf/config_dev.yml`` or ``app/conf/config_test.yml`` file
    to override default parameters. You will be able to use a different database, mailer or *Solr* instance not to pollute your production environment.

.. topic:: Source Edition

    *Roadiz Source edition* stores configuration files in ``conf/`` folder.

Doctrine
--------

The most important configuration section deals with database connection which is handled by *Doctrine*:

.. code-block:: yaml

    doctrine:
        driver: "pdo_mysql"
        host: "localhost"
        user: ""
        password: ""
        dbname: ""

Roadiz uses *Doctrine ORM* to store your data. It will directly pass this YAML configuration to *Doctrine* so
you can use every available drivers and options from its documentation at
http://doctrine-dbal.readthedocs.org/en/latest/reference/configuration.html

Cache drivers
-------------

When set as *null*, cache drivers will be automatically chosen by Roadiz according to
your PHP setup and available extensions.

Sometimes, if a cache extension is available but you don’t want to use it, you’ll
have to specify a cache driver type (use ``array`` to disable caches). This is a known case
when using *OVH* shared hosting plans which provide *memcached* PHP extension but does not let you log in.

.. code-block:: yaml

    cacheDriver:
        type: null
        host: null
        port: null

Available cache types are:

- *apc*
- *xcache*
- *memcache* (requires ``host`` and ``port`` configuration)
- *memcached* (requires ``host`` and ``port`` configuration)
- *redis* (requires ``host`` and ``port`` configuration)
- *array*

.. _monolog_handlers:

Monolog handlers
----------------

By default, Roadiz writes its logs to ``app/logs/`` folder in a file named after your running environment (eg. ``roadiz_prod.log``).
But you can also customize *Monolog* to use three different handlers. Pay attention that using custom log handlers will
disable default Roadiz logging (except for *Doctrine* one) so it could be better to always use *default* handler along
a custom one.

Available handler types:

- ``default``: Reproduce the Roadiz default handler which writes to ``app/logs/`` folder in a file named after your running environment
- ``stream``: Defines a log file stream on your local system. **Your path must be writable!**
- ``syslog``: Writes to system *syslog*.
- ``gelf``: Send GELF formatted messages to an external entry point defined by *url* value. Roadiz uses a fault tolerant handler which **won’t trigger any error** if your path is not reachable, so make sure it’s correct. It’s a good idea to combine a *gelf* handler with a local logging system if your external entry point is down.

``type`` and ``level`` values are mandatory for each handlers.

Here is an example configuration:

.. code-block:: yaml

    monolog:
        handlers:
            default:
                type: default
                level: INFO
            file:
                type: stream
                # Be careful path must be writable by PHP
                path: /var/log/roadiz.log
                level: INFO
            syslog:
                type: syslog
                # Use a custom identifier
                ident: my_roadiz
                level: WARNING
            graylog:
                type: gelf
                # Gelf HTTP entry point url (with optional user:passwd authentication)
                url: http://graylog.local:12202/gelf
                level: WARNING


.. _solr_endpoint:

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
        - "../vendor/roadiz/roadiz/src/Roadiz/Core/Entities"
        - "../vendor/roadiz/models/src/Roadiz/Core/AbstractEntities"
        - "gen-src/GeneratedNodeSources"


Configure mailer
----------------

Roadiz uses *Swift Mailer* to send emails. This awesome library is built to enable different
kinds of mail transports and protocols. By default, Roadiz uses your PHP ``sendmail`` configuration
but you can tell it to use another transport (such as an external SMTP server) in your ``app/conf/config.yml`` file.

You can use *SSL*, *TLS* or no encryption at all.

.. code-block:: yaml

    mailer:
        type: "smtp"
        host: "localhost"
        port: 25
        encryption: false
        username: ""
        password: ""

.. note::
    Pay attention that many external SMTP services (*Mandrill*, *Mailjet*…) only accept email from validated domains.
    So make sure that your application uses a known ``From:`` email sender not to be blacklisted or blocked
    by these services.
    If you need your emails to be replied to an anonymous address, use ``ReplyTo:`` header instead.

Images processing
-----------------

Roadiz use `Image Intervention <http://image.intervention.io/>`_ library to automatically create a lower quality
version of your image if they are too big. You can define this threshold value
in the ``assetsProcessing`` section. ``driver`` and ``defaultQuality`` will be also
use for the on-the-fly image processing with `Intervention Request <https://github.com/ambroisemaupate/intervention-request>`_ library.

.. code-block:: yaml

    assetsProcessing:
        # gd or imagick (gd does not support TIFF and PSD formats)
        driver: gd
        defaultQuality: 90
        # pixel size limit () after roadiz
        # should create a smaller copy.
        maxPixelSize: 1280
        # Path to jpegoptim binary to enable jpeg optimization
        jpegoptimPath: ~
        # Path to pngquant binary to enable png optimization (3x less space)
        pngquantPath: ~
        # List additionnal Intervention Request subscribers
        subcribers: []

Additionnal *Intervention Request* subscribers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Any *Intervention Request* subscriber can be added to configuration with its ``classname``
and its constructor arguments. Here is an example with ``WatermarkListener`` which will
print some text on all your images.

.. code-block:: yaml

    assetsProcessing:
        # List additionnal Intervention Request subscribers
        subcribers:
            - class: "AM\\InterventionRequest\\Listener\\WatermarkListener"
              args:
                   - 'Copyright 2017'
                   - 3
                   - 50
                   - "#FF0000"

Use kraken.io to reduce drastically image sizes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since you can add *Intervention Request* subscribers, we created a useful one that sends
every images to `kraken.io <https://kraken.io/>`_ services to shrink them. Once you’ve configured it,
do not forget to empty your caches **and** image caches to see changes.

.. code-block:: yaml

    assetsProcessing:
        # List additionnal Intervention Request subscribers
        subcribers:
            - class: "AM\\InterventionRequest\\Listener\\KrakenListener"
              args:
                   - "your-api-key"
                   - "your-api-secret"
                   - true

.. warning::

    Take note that each generated image is sent to *kraken.io* servers. It can generate some overhead
    time on the first time you request an image.

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
commands which can alter your database and make you lose precious data. Especially when you will need to update
your database schema after a Theme or a Core update. **Always make a database back-up before any Doctrine operation**.

Additional commands
-------------------

If you are developing your own theme, you might need to create some custom CLI commands. Roadiz can handle
additional commands if you add them in your ``app/conf/config.yml`` as you would do for any additional *entities*.
Make sure that every additional commands extend ``Symfony\Component\Console\Command\Command`` class.

.. code-block:: yaml

    additionalCommands:
        - \Themes\DefaultTheme\Commands\DefaultThemeCommand
