.. _docker:

Using Docker for development
============================

Roadiz standard edition is shipped with a ``docker-compose`` example environment ready
to use for development. *Docker* on Linux will provide awesome performances and a production-like environment
without bloating your development machine. Performances won't be as good on *macOS* or *Windows* hosts,
but it will prevent installing singled versioned PHP and MySQL directly on your computer.

First, copy ``.env.dist`` file to  ``.env`` and configure it according to your host machine.

.. code-block:: bash

    # Copy sample environment variables
    # and adjust them against your needs.
    # Especially APP_PORT when you're working on several projects
    cp .env.dist .env;

    # Build PHP image
    docker-compose build;

    # Create and start containers
    docker-compose up -d;

Then your website will be available at ``http://localhost:${APP_PORT}``.

For linux users, where *Docker* is running natively (without underlying virtualization),
pay attention that *PHP* is running with *www-data* user. You must update your ``.env`` file to
reflect your local user **UID** during image build.

.. code-block:: bash

    # Type id command in your favorite terminal app
    id
    # It should output something like
    # uid=1000(toto)


So use the same uid in your `.env` file **before** starting and building your Docker image.

.. code-block:: bash

    USER_UID=1000

