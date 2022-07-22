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
* PHP 7.4+ **required**
* ``php-gd`` extension
* ``php-intl`` extension
* ``php-xml`` extension
* ``php-curl`` extension
* ``php-mbstring`` extension
* JSON needs to be enabled
* ctype needs to be enabled
* Your php.ini needs to have the ``date.timezone`` setting
* You need to have at least version 2.6.21 of libxml
* PHP tokenizer needs to be enabled
* PHP *OPcache* + *APCu* (APC 3.0.17+ or another opcode cache needs to be installed)
* ``php.ini`` recommended settings

    - ``short_open_tag = Off``
    - ``magic_quotes_gpc = Off``
    - ``register_globals = Off``
    - ``session.auto_start = Off``

* MariaDB 10.5.2+ or MySQL 5.7+ database with `JSON_*` functions support
* Zip/Unzip
* cUrl
* Composer
* Git

.. note::
    If you get request timeouts, your hosting provider might be blocking your SSH connectivity.
    You should consider using at least a VPS-like hosting.
