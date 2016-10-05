.. _docker:

Using Docker for production
===========================

Once you’ve developed your Roadiz website with your dedicated theme with *Vagrant*
you’ll need to push your website to production. We’ve built a *Docker* image
to ease up and speed up deployment.

.. note::

    Docker deployment require knowledge with *Docker* and some sys-admin skills. We invite you
    to familiarize with this technology, there is `a plenty of documentation on the subject <https://www.docker.com/what-docker>`_.

As a Roadiz website requires a database server and some SSH protocol to transfer
your local data, it will be more convenient to deploy using `Docker Compose <https://docs.docker.com/compose/compose-file/>`_. It will
orchestrate each container with their volumes and link them together.

A simple docker-compose example
-------------------------------

In a blank folder named `site/` create a `docker-compose.yml` file
with the following content:

.. code-block:: yaml

    version: '2'
    services:
      MAIN:
        hostname: site
        image: ambroisemaupate/roadiz
        environment:
          ROADIZ_BRANCH: develop
        ports:
          - "8080:80"
        volumes:
          - DATA:/data
        links:
          - DB:mariadb
        depends_on:
          - DB
        # For production only
        restart: always
      DB:
        image: ambroisemaupate/mariadb
        environment:
          MARIADB_USER: "username"
          MARIADB_PASS: "password"
        volumes:
          - DBDATA:/data
      # SSH container linked to db to
      # export or import mysqldumps and
      # sync your files from/to your local server
      SSH:
        image: ambroisemaupate/light-ssh
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

After your container launch, you’ll find a blank Roadiz install with no theme, and no data.
Before copying your data (``files/`` folder) you’ll need to pull your theme from a *git*
repository.

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

    # Clone your custom theme
    cd /data/http/themes
    git clone git@github.com:private-account/custom-theme.git CustomTheme
    # Install your theme composer dependencies (if any)
    cd /data/http
    composer update --no-dev -o

Configure Roadiz
----------------

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

Roadiz docker image does not provide any mail transport agent. You’ll need to
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

Copy data from your local environment with the SSH container
------------------------------------------------------------


