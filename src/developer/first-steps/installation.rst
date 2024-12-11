.. _installation:

===========================
Create a new Roadiz project
===========================

For new projects **Roadiz** can be easily setup using ``create-project`` command and our *Skeleton*.

.. code-block:: bash

    # Create a new Roadiz project
    composer create-project roadiz/skeleton my-website
    cd my-website
    # Create a local Dotenv to store your secrets
    cp .env .env.local
    # Edit your docker compose parameter in .env to
    # fit your development environment (OS, UID).
    # .env file will be tracked by Git
    #
    # Customize docker compose.yml file to set your stack name
    #
    # Initialize your Docker environment
    docker compose build
    docker compose up -d --force-recreate

.. warning::

    **Roadiz** and **Symfony** development and production environments heavily rely on `Docker <https://docs.docker.com/get-started/>`_
    and `docker compose <https://docs.docker.com/compose/>`_. We recommend you to learn these awesome tools if you're not
    using them yet.
    You still can use Roadiz without Docker, but you will have to install and configure a *PHP* environment, *MySQL* database, and a web server. If you are not using *docker* or *docker compose*, just ignore ``docker compose exec app`` prefix in the following commands.

.. note::

    Keep in mind that Roadiz v2 is a complete rewrite to become a true *Symfony* Bundle, it is true a *Symfony* app and behaves like that.
    Roadiz v2 is meant to be used as a headless CMS with *API Platform*. But you still can use *Controllers* and *Twig* templates, but there is no more theme logic, just Symfony Bundles and your own code (in ``./src`` folder).

*Composer* will prompt you if you want to can versioning history. Choose the default answer ``no`` as we definitely
want to replace *roadiz/skeleton* *Git* with our own versioning. Then you will be able to customize every files
in your projects and save them using Git, not only your theme. Of course we added a default ``.gitignore`` file to
prevent your configuration setting and entry points to be committed in your *Git* history. That way you can have
different configuration on development and on your production server without bothering about merge conflicts.

Generate JWT private and public keys
------------------------------------

When using `composer create-project` command, you should have JWT secret and certificate automatically generated.
If not, you can generate them using the following commands:

.. code-block:: bash

    # Generate Symfony secrets
    docker compose exec app bin/console secrets:generate-keys;
    # Set a random passphrase for Application secret and JWT keys
    docker compose exec app bin/console secrets:set APP_SECRET --random;
    docker compose exec app bin/console secrets:set JWT_PASSPHRASE --random;
    # Use built-in command to generate your key pair
    docker compose exec app bin/console lexik:jwt:generate-keypair;


Install database
----------------

.. code-block:: bash

    # Create and migrate Roadiz database schema
    docker compose exec app bin/console doctrine:migrations:migrate
    # Migrate any existing data types
    docker compose exec app bin/console app:install
    # Install base Roadiz fixtures, default translation, roles and settings
    docker compose exec app bin/console install
    # Stop workers to force restart them
    docker compose exec app php bin/console messenger:stop-workers
    # Clear cache
    docker compose exec app bin/console cache:clear
    # Create your admin account
    docker compose exec app bin/console users:create -m username@roadiz.io -b -s username


Then connect to ``http://localhost:${YOUR_PORT}/rz-admin`` to access your freshly-created Roadiz backoffice.

.. note::

    If you setup `Traefik <https://doc.traefik.io/traefik/>`_ on your local environment, you can reach your Roadiz app using your ``domain.test``
    test domain name without specifying a non-default port. You have to change ``HOSTNAME`` dot-env variable and
    change your local DNS to point ``domain.test`` to ``127.0.0.1``.
    The easiest way is to add ``127.0.0.1 domain.test`` to your ``/etc/hosts`` file.
