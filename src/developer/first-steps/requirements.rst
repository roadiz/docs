.. _getting-started:

============
Requirements
============

.. _requirements:

Roadiz is a Symfony application running with PHP. You can follow regular `Symfony requirements <https://symfony.com/doc/5.4/setup.html#technical-requirements>`_ to
optimize your local or production setup.
Roadiz requires an HTTP server for static assets and **SSH access** with out/ingoing allowed connections.
Here is a short summary of mandatory elements before installing Roadiz:

* Nginx or Apache, with a dedicated virtual host as described below.
* PHP 8.1+ **required**, 8.2 recommended
* Install theses PHP extensions (which are installed and enabled by default in most PHP installations): JSON, Intl, cURL, MBString, Ctype, iconv, PCRE, Session, Zip, SimpleXML, and Tokenizer;
* Your php.ini needs to have the ``date.timezone`` setting
* You need to have at least version 2.6.21 of libxml
* PHP *OPcache*
* ``php.ini`` recommended settings

    - ``short_open_tag = Off``
    - ``magic_quotes_gpc = Off``
    - ``register_globals = Off``
    - ``session.auto_start = Off``

* MariaDB 10.5.2+ or MySQL 8.0+ database with `JSON_*` functions support
* Install `Composer <https://getcomposer.org/download/>`_, which is used to install PHP packages.
* Git

Roadiz is a Symfony application
-------------------------------

Roadiz is not meant to be deployed directly on a production server right out-of-the-box, it is a Symfony application that you must configure and customize on your development environment then commit your own project repository configuration, migrations. Then you will be able to deploy it using your preferred method (SFTP / SSH / Git / Docker). Remember that as you would do with any Symfony app, you'll have to clear cache, run migrations and other stuff each time you deploy to a new environment. This may require a SSH access to your production env or building a Docker image with a custom entrypoint script.

Using Docker as a development and production environment
--------------------------------------------------------

**Roadiz** and **Symfony** development and production environments heavily rely on `Docker <https://docs.docker.com/get-started/>`_
and `docker compose <https://docs.docker.com/compose/>`_ because it eases up development and deployments stages using tools such as *Gitlab* or *Github Actions*. We recommend creating Docker images containing **all your project sources and dependencies**.

*Roadiz Skeleton* project includes a multi-stage ``Dockerfile`` with PHP, Nginx and Varnish. Feel free to customize it according to your project needs.
You can use ``docker-bake.hcl`` in you CI pipeline to build all your project Docker images at once.

``docker compose`` is meant to be used on the host machine (especially on Windows and macOs hosts). *Docker* is not mandatory if you prefer to install PHP and a web server directly on your host, just follow official Symfony instructions : https://symfony.com/doc/current/setup.html#technical-requirements


One container per process
^^^^^^^^^^^^^^^^^^^^^^^^^

Since Roadiz v2.1, we recommend separating processes into different docker containers. This allows you to scale each process independently. For example, you can have multiple PHP-FPM containers running your application, but only one Nginx container serving static assets. You can also have multiple PHP-FPM containers running your application, but only one Redis container for your cache. This allows you to scale each process independently.
