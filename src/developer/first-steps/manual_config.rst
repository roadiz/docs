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

Choose your inheritance model
-----------------------------

*Roadiz’* main feature is all about its polymorphic document model which is mapped on a relational database. This requires a
challenging structure which can be lead to some performance bottlenecks when dealing with more than 20-30 node-types.
So we made the data inheritance model configurable to allow switching to `single_table <https://www.doctrine-project.org/projects/doctrine-orm/en/2.7/reference/inheritance-mapping.html#single-table-inheritance>`_ scheme which will be more performant
if you need lots of node-types. However *Single class* model will drop support for indexable fields and you won’t be able
to create fields with the *same name but not the same type* because all node-type fields will be created in the **same SQL table**.

If you really need to create indexable fields and to mix field types, we advise you to keep the original `joined table <https://www.doctrine-project.org/projects/doctrine-orm/en/2.7/reference/inheritance-mapping.html#class-table-inheritance>`_
inheritance type which creates a dedicated SQL table for each node-type. *Joined table* inheritance can be very useful
with a small number of node-type (max. 20) and very different fields. But its main drawback is that Roadiz needs to *LEFT JOIN*
every node-type table for each node-source query, **unless you specify one node-type criteria**.

You can configure *Doctrine* strategy for NodesSources inheritance classes in ``app/conf/config.yml``:

.. code-block:: yaml

    inheritance:
        # type: joined
        type: single_table

- Joined class inheritance: ``joined``
- Single table inheritance: ``single_table``

.. warning::

    If you change this setting after creating content in your website, all node-sources data will be lost.

Themes
------

Since *Roadiz v1.0*, themes are statically registered into Roadiz configuration for better performances
and delaying database usage. You have to register any front-end theme in your ``app/conf/config.yml`` file.
Theme priority is not handled here but in each of your themes by overriding static ``$priority`` value;

.. code-block:: yaml

    themes:
        -
            classname: \Themes\DefaultTheme\DefaultThemeApp
            hostname: '*'
            routePrefix: ''
        -
            classname: \Themes\FooBarTheme\FooBarThemeApp
            hostname: 'foobar.test'
            routePrefix: ''

You can define hostname specific themes and add a route-prefix for your routing. Defaults values
are ``'*'`` for the *hostname* and ``''`` (empty string) for the route-prefix.

.. warning::

    No theme configuration will lead into a 404 error on your website home page. But you will still have
    access to the back-office which is now hard-registered into Roadiz configuration.

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
- ``sentry``: Send logs to your *Sentry* instance. **Requires sentry/sentry PHP library**: ``composer require sentry/sentry php-http/curl-client guzzlehttp/psr7``. It’s a good idea to combine a *sentry* handler with a local logging system if your external entry point is down.

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
            sentry:
                type: sentry
                level: WARNING
                url: https://xxxxxx:xxxxxx@sentry.io/1


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
                path: "/"
                core: "mycore"
                timeout: 3
                username: ""
                password: ""

Roadiz CLI command can easily handle Solr index. Just type ``./bin/roadiz solr:check`` to get
more informations.

Reverse proxy cache invalidation
--------------------------------

Roadiz can request cache invalidation to external and internal cache proxies such as internal
*Symfony* AppCache or a *Varnish* instance. If configured, Roadiz will create a ``BAN`` request
to each configured proxy **when user clears back-office caches**, and it will create a ``PURGE`` request
**on each node-source** *update event* using first reachable node-source URL.

.. code-block:: yaml

    reverseProxyCache:
        frontend:
            localhost:
                host: localhost
                domainName: myapp.test
            external:
                host: varnish
                domainName: myapp.test

.. note::

    Make sure you `configured your external reverse proxy <https://github.com/roadiz/roadiz/blob/develop/samples/varnish_default.vcl>`_
    in order to receive and handle ``BAN`` and ``PURGE`` HTTP requests.


Cloudflare proxy cache
^^^^^^^^^^^^^^^^^^^^^^

If you are using Cloudflare as a reverse proxy cache, you can configure Roadiz to send requests to Cloudflare
to purge all items or files (when editing a node-source). You need to gather following information:

- Cloudflare zone identifier
- Cloudflare API credentials (Bearer token or email + auth-key)

Then you can configure Roadiz with Bearer token:

.. code-block:: yaml

    reverseProxyCache:
        frontend: []
        cloudflare:
            zone: cloudflare-zone
            bearer: ~

Or with your Email and AuthKey:

.. code-block:: yaml

    reverseProxyCache:
        frontend: []
        cloudflare:
            zone: cloudflare-zone
            email: ~
            key: ~

.. note::

    Roadiz uses *Purge all files* and *Purge Files by URL* entry points: https://api.cloudflare.com/#zone-purge-all-files
    which are available on all Cloudflare plans.

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

Additional *Intervention Request* subscribers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Console commands
----------------

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

