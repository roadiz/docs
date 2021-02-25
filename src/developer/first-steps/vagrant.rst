.. _vagrant:

Using Vagrant for development
=============================

Roadiz comes with a dedicated ``Vagrantfile`` which is configured to run the official ``roadiz/standard-edition`` box with a *LEMP* stack
(Nginx + PHP7.0-FPM + MariaDB), a *phpMyAdmin*, a *Mailcatcher* and an *Apache Solr server*. This will be useful
to develop your website on your local computer.

.. note::

    *Git*, *Composer*, *Virtual Box* and *Vagrant* must be setup on your local computer before going
    further into Vagrant development.

    - https://getcomposer.org/download/
    - https://www.virtualbox.org/
    - https://www.vagrantup.com/

Once you’ve created your Roadiz project, *Composer* should has copied ``samples/Vagrantfile.sample`` file
as ``Vagrantfile`` at your project root.
Then do a ``vagrant up`` in Roadiz’ folder. Then `Vagrant <https://www.vagrantup.com/>`_ will run your code in ``/var/www``
and you will be able to completely use ``bin/roadiz`` commands without bloating your computer with lots of binaries.

Once vagrant VM has provisioned you will be able to use:

* ``http://192.168.33.10/install.php`` to proceed to install.
* ``http://192.168.33.10:8983/solr`` to use *Apache Solr* admin.
* ``http://192.168.33.10/phpmyadmin`` for your *MySQL* db admin.
* ``http://192.168.33.10:1080`` for your *Mailcatcher* tool.

Do not hesitate to add an entry in your ``/etc/hosts`` file to use a local *domain name*
instead of using the private IP address (eg. http://site1.dev). And for each Vagrant website, **do not forget to increment your private IP**.

.. code-block:: bash

    # /etc/hosts
    # Vagrant hosts
    192.168.33.10    site1.dev
    192.168.33.11    site2.dev
    # …

.. note::
    Be careful, **Windows users**, this ``Vagrantfile`` is configured to use a *NFS* fileshare.
    Disable it if you did not setup a *NFS* emulator. For *OS X* and *Linux* user
    this is built-in your system, so have fun!

Access entry-points
-------------------

``web/install.php``, ``web/clear_cache.php`` and ``web/dev.php`` entry points are IP restricted to *localhost*. To be able to use them
with a *Vagrant* setup, you’ll need to add your host machine IP to the ``$allowedIp`` array. We already
set two IP for you that should work for *forwarded* and *private* requests. Just uncomment the following lines
in these files and edit them if necessary.

.. code-block:: php

    $allowedIp = [
        '10.0.2.2',     // vagrant host (forwarded)
        '192.168.33.1', // vagrant host (private)
        '127.0.0.1', 'fe80::1', '::1' // localhost
    ];

Database and Solr credentials
-----------------------------

Roadiz *Vagrant* box provides standard *MariaDB* and *Apache Solr* servers which run automatically at launch.
Here are their default credentials:

.. rubric:: Database credentials

- Host: ``localhost``
- User: ``roadiz``
- Password: ``roadiz``
- Database: ``roadiz`` or ``roadiz_test`` (for executing unit tests)

.. rubric:: *Solr* credentials

- Host: ``localhost``
- Core: ``roadiz`` or ``roadiz_test`` (for executing unit tests)
- User: *none*
- Password: *none*


.. warning::

    Of course, this *Vagrant* virtual machine should not be used for any *production* environment. You can find
    provisioning scripts on our `Github repository <https://github.com/roadiz/vagrant-box>`_, feel free to make enhancement
    sugggestions about them.


Full config.yml example for Vagrant
-----------------------------------

.. code-block:: yaml

    ---
    appNamespace: "my-roadiz-project"
    timezone: "Europe/Paris"
    doctrine:
        driver: "pdo_mysql"
        host: "localhost"
        user: "roadiz"
        password: "roadiz"
        dbname: "roadiz"
        charset: utf8mb4
        default_table_options:
            charset: utf8mb4
            collate: utf8mb4_unicode_ci
    cacheDriver:
        type: ~
        host: ~
        port: ~
    security:
        secret: "my-roadiz-project"
    mailer:
        type: ~
        host: "localhost"
        port: 25
        encryption: false
        username: ""
        password: ""
    entities:
        - ../vendor/roadiz/roadiz/src/Roadiz/Core/Entities
        - ../vendor/roadiz/models/src/Roadiz/Core/AbstractEntities
        - gen-src/GeneratedNodeSources
    rememberMeLifetime: 2592000
    additionalServiceProviders: []
    additionalCommands: []
    assetsProcessing:
        driver: gd
        defaultQuality: 90
        maxPixelSize: 1920
        jpegoptimPath: /usr/bin/jpegoptim
        pngquantPath: /usr/bin/pngquant
    solr:
        endpoint:
            localhost:
                host: "localhost"
                port: "8983"
                path: "/solr"
                core: "roadiz"
                timeout: 3
                username: ""
                password: ""


