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
    # Edit your docker-compose parameter in .env.local or .env to
    # fit your development environment (OS, UID)
    # Initialize your Docker environment
    docker-compose build
    docker-compose up -d --force-recreate

*Composer* will prompt you if you want to can versioning history. Choose the default answer ``no`` as we definitely
want to replace *roadiz/skeleton* *Git* with our own versioning. Then you will be able to customize every files
in your projects and save them using Git, not only your theme. Of course we added a default ``.gitignore`` file to
prevent your configuration setting and entry points to be committed in your *Git* history. That way you can have
different configuration on development and on your production server without bothering about merge conflicts.

Generate JWT private and public keys
------------------------------------

.. code-block:: bash

    # Generate a strong secret
    openssl rand --base64 16;
    # Fill JWT_PASSPHRASE env var.
    openssl genpkey -out config/jwt/private.pem -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096;
    openssl pkey -in config/jwt/private.pem -out config/jwt/public.pem -pubout;


Install database
----------------

.. code-block:: bash

    # Create Roadiz database schema
    docker-compose exec -u www-data app bin/console doctrine:migrations:migrate
    # Migrate any existing data types
    docker-compose exec -u www-data app bin/console themes:migrate ./src/Resources/config.yml
    # Install base Roadiz fixtures, roles and settings
    docker-compose exec -u www-data app bin/console install
    # Clear cache
    docker-compose exec -u www-data app bin/console cache:clear
    # Create your admin account
    docker-compose exec -u www-data app bin/console users:create -m username@roadiz.io -b -s username


Then connect to ``http://localhost:YOUR_PORT/rz-admin`` to access your freshly-created Roadiz backoffice.
