.. _docker:

Using Docker for production
===========================

Once you’ve developed your Roadiz website with your dedicated theme with *Vagrant*
you’ll need to push your website to production. We’ve built a *Docker* image
to ease up and speed up deployment.

.. note::

    Docker deployment requires knowledge with *Docker* and some sys-admin skills. We invite you
    to familiarize with this technology, there is `a plenty of documentation on the subject <https://www.docker.com/what-docker>`_.

As a Roadiz website requires a database server and some SSH protocol to transfer
your local data, it will be more convenient to deploy using `Docker Compose <https://docs.docker.com/compose/compose-file/>`_. It will
orchestrate each container with their volumes and link them together.

A simple docker-compose example
-------------------------------

In a blank folder named `site/` create a `docker-compose.yml` file
with the following content:

.. code-block:: yaml

    version: '3'
    services:
      MAIN:
        hostname: site
        image: roadiz/standard-edition
        # Only if you are using a proxy or/and backup container
        #network_mode: "bridge"
        ports:
          # For production only without a proxy
          - "80:80"
        volumes:
          - DATA:/data
        links:
          - DB:mariadb
        depends_on:
          - DB
        # For production only
        restart: always
        healthcheck:
          test: ["CMD", "curl", "-f", "http://localhost"]
          interval: 5m0s
          timeout: 5s
          retries: 3
      DB:
        image: ambroisemaupate/mariadb
        environment:
          MARIADB_USER: "username"
          MARIADB_PASS: "password"
        # Only if you are using a proxy or/and backup container
        #network_mode: "bridge"
        volumes:
          - DBDATA:/data
      # SSH container linked to db to
      # export or import mysqldumps and
      # sync your files from/to your local server
      SSH:
        image: ambroisemaupate/light-ssh
        # Only if you are using a proxy or/and backup container
        #network_mode: "bridge"
        environment:
          PASS: "password"
        volumes:
          - DATA:/data
        links:
          - DB:mariadb
        depends_on:
          - DB
        ports:
          - "22/tcp"
    volumes:
      DATA:
      DBDATA:

Then launch your container network with ``docker-compose up -d``. This will create:

- ``site_MAIN_1`` container
- ``site_DB_1`` container
- ``site_SSH_1`` container
- ``site_DATA`` volume
- ``site_DBDATA`` volume

After your container launch, you’ll find a blank ``/data/http`` folder in which you’ll have to clone your
Roadiz application. Then you’ll be able to import your database and your files (``bin/roadiz files:import yourZipFile.zip``).

Using a deploy/access key for Github/Gitlab
-------------------------------------------

Roadiz docker image is configured to look for your *SSH* public key in ``/data/secure/ssh``.
Pay attention to generate you *ssh-key* as ``core`` user: ``su -s /bin/bash core``
before doing anything in your ``/data`` folder.

.. code-block:: bash

    # On your Docker host, access to your main container
    # You must impersonate core user
    docker exec -ti --user=core site_MAIN_1 bash

    # On your docker container…
    # Generate public/private keys
    ssh-keygen -t rsa -b 2048 -N '' -f /data/secure/ssh/id_rsa \
               -C "Deploy key ($HOSTNAME) for private repository"
    # Add the generated /data/secure/ssh/id_rsa.pub key to your Github/Gitlab account

    # Clone your Roadiz standard edition application
    cd /data/http/
    git clone git@github.com:private-account/my-roadiz-app.git ./
    # Install composer dependencies
    composer install --no-dev
    composer dump-autoload --no-dev -o -a

Configure Roadiz
----------------

To configure your Roadiz website, edit your ``/data/http/app/conf/config.yml`` with *nano* editor.
If you get some *"Unknown terminal error"*, you have to edit your TERM environment variable: ``export TERM=xterm``.

Database
^^^^^^^^

.. code-block:: yaml

    doctrine:
        driver: pdo_mysql
        # Pay attention that DB host is not localhost but
        # mariadb as we defined an alias in our
        # docker-compose.yml file.
        host: mariadb
        user: username
        password: password
        # DB name will automatically be named after username
        dbname: username
        port: null
        unix_socket: null
        path: null

Mailer
^^^^^^

Roadiz docker image **does not provide any mail transport agent**. You’ll need to
subscribe to an external SMTP service if your website needs to send emails.
You can also link your Roadiz container with a dockerized *Postfix* service. In every cases
you’ll have to fill in *mailer* details in configuration.

.. code-block:: yaml

    mailer:
        type: smtp
        host: smtp-provider.com
        port: 25
        encryption: false
        username: ''
        password: ''

Logs
^^^^

See manual configuration documentation section about :ref:`monolog_handlers`.

Copy data from your local environment with the SSH container
------------------------------------------------------------

.. note::

    We assume that you won’t do a fresh install of your website with *Docker*. So
    you won’t need to access to the ``install.php`` entry point.

To copy your data from your local environment you will use your *SSH* container
to perform some ``scp`` and ``rsync`` commands between your computer and your
Docker container. Using a SSH container has the great advantage to start and stop
the server whenever you need it and to completely secure your data from outside.
Obviously, your Docker host SSH account must be securized too (*public key only* connection for root
or ``sudo`` *only* connections).

Pushing database
^^^^^^^^^^^^^^^^

#. Export a *MySQL* dump from your *Vagrant* or other local development: ``bin/roadiz database:dump -c``.
#. Make sure your *SSH* container is started and find its public port: ``docker start site_SSH_1``.
#. Copy from your computer to your *Docker* container: ``scp -P XXXXX local/path/site_2016_10_07.sql core@site.com:/data/secure/``.
#. Connect to your Docker container: ``ssh -p XXXXX core@site.com``.
#. Import your dump: ``cd /data/secure; mysql -hmariadb -uusername -p username < site_2016_10_07.sql;``.
#. Regenerate your entities: ``cd /data/http; bin/roadiz generate:entities;``.

Pushing documents and fonts
^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Make sure your *SSH* container is started and find its public port: ``docker start site_SSH_1``.
#. Send your ``.zip`` archive generated with ``bin/roadiz files:export`` command to your Docker container.
#. Execute ``bin/roadiz files:import yourZipArchive.zip`` command to store files in Roadiz folders.

Clear cache
^^^^^^^^^^^

#. Connect to your real Docker *Roadiz* container. **Not the SSH one**: ``docker exec -ti --user=core site bash``.
#. Call the ``clear_cache.php`` entry point with ``curl`` command: ``curl http://localhost/clear_cache.php``.

Use a proxy to secure your containers
-------------------------------------

For better security and *SSL support* with awesome and free *Let’s Encrypt* certificates,
you can use `jwilder/nginx-proxy <https://github.com/jwilder/nginx-proxy>`_ and
`JrCs/docker-letsencrypt-nginx-proxy-companion <https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion>`_ Docker images.
Then you won’t need to publish your *Roadiz* ports anymore but to declare environment
variables called ``VIRTUAL_HOST``, ``LETSENCRYPT_HOST`` and ``LETSENCRYPT_EMAIL`` to bind *nginx front proxy* to your container.

.. note::

    As *Docker Compose* encapsulates every composed services in their own network, you have to
    explicitely set ``network_mode: "bridge"`` mode. Without this setting, your front proxy
    container won’t be able to reach your Roadiz container. This network mode is also required if you
    need to run temporary containers linked to your database, for example a *backup* service.
    If you are using *Docker compose* also for your *Nging proxy* setup, do not forget to add it
    in its ``docker-compose.yml`` too.

.. code-block:: yaml

    version: '2'
    services:
      MAIN:
        hostname: site
        image: roadiz/standard-edition
        network_mode: "bridge"
        environment:
          # Bind nginx proxy to listen these domains
          VIRTUAL_HOST: site.com,www.site.com
          # Create and renew SSL cert for these domains
          LETSENCRYPT_HOST: site.com,www.site.com
          # Mandatory administration email for renewal notifications
          LETSENCRYPT_EMAIL: admin@site.com
          # …

You have to understand that using a *front-proxy* will obfuscate your visitors IP inside
your Roadiz container. You’ll have to trust the proxy request to get real remote IP and
protocol. (See :ref:`reverse_proxy`)

Use Solr
--------

See `Solr docker image documentation <https://hub.docker.com/_/solr/>`_.

.. code-block:: yaml

    version: '3'
    services:
      MAIN:
        hostname: site
        image: roadiz/standard-edition
        environment:
        # Only if you are using a proxy or/and backup container
        #network_mode: "bridge"
        ports:
          # For production only without a proxy
          - "80:80"
        volumes:
          - DATA:/data
        links:
          - DB:mariadb
          - SOLR:solr
        depends_on:
          - DB
          - SOLR
        # For production only
        restart: always
      SOLR:
        image: solr
        # Only if you are using a proxy or/and backup container
        #network_mode: "bridge"
        entrypoint:
          - docker-entrypoint.sh
          - solr-precreate
          - site
        volumes:
          - SOLRDATA:/opt/solr/server/solr/mycores
    #
    # …
    #
    volumes:
      DATA:
      DBDATA:
      SOLRDATA:

Then configure you Roadiz website to connect it to your Solr server (see :ref:`solr_endpoint`).
Do not forget to use ``solr`` hostname and ``site`` core name.
