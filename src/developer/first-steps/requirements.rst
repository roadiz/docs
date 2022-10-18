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
* PHP 7.4+ **required**, 8.1 recommended
* Install theses PHP extensions (which are installed and enabled by default in most PHP installations): JSON, Intl, cURL, MBString, Ctype, iconv, PCRE, Session, Zip, SimpleXML, and Tokenizer;
* Your php.ini needs to have the ``date.timezone`` setting
* You need to have at least version 2.6.21 of libxml
* PHP *OPcache* + *APCu* (APC 3.0.17+ or another opcode cache needs to be installed)
* ``php.ini`` recommended settings

    - ``short_open_tag = Off``
    - ``magic_quotes_gpc = Off``
    - ``register_globals = Off``
    - ``session.auto_start = Off``

* MariaDB 10.5.2+ or MySQL 5.7+ database with `JSON_*` functions support
* Install `Composer <https://getcomposer.org/download/>`_, which is used to install PHP packages.
* Git

.. warning::

    **Roadiz** and **Symfony** development and production environments heavily rely on `Docker <https://docs.docker.com/get-started/>`_
    and `docker-compose <https://docs.docker.com/compose/>`_. We recommend you to learn these awesome tools if you're not
    using them yet.

    You can use our `official Docker image <https://hub.docker.com/r/roadiz/php81-nginx-alpine>`_ with *Nginx* and *PHP* already setup for you.
    We recommend that you create your own Docker image based on this official one.
