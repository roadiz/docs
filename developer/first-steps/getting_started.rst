.. _getting-started:

===============
Getting started
===============


CMS Structure
-------------

* ``bin/`` : Contains the Roadiz CLI executable
* ``cache/`` : Every cache file for *Twig* templates and `Intervention Request <https://github.com/roadiz/roadiz/releases>`_ images (this folder must be writable for PHP)
* ``conf/`` : Your setup configuration file(s) (this folder must be writable for PHP)
* ``files/`` : Documents and font files root (this folder must be writable for PHP)
* ``gen-src/`` : Generated PHP code for Doctrine and your Node-types entities (this folder must be writable for PHP)
* ``samples/`` : This folder contains useful configuration and example files for Apache or Nginx webservers
* ``src/`` : Roadiz CMS logic and core source code
* ``tests/`` : PHP Unit tests root
* ``themes/`` : Contains your themes and system themes such as *Rozier* and *Install*
* ``vendor/`` : Dependencies folder managed by *Composer*
* ``logs/`` : *Monolog* logs folder

.. _requirements:

Requirements
------------

Roadiz is a web application running with PHP. It requires an HTTP server for static assets and **SSH access** with out/ingoing allowed connections.
Here is a short summary of mandatory elements before installing Roadiz:

* Nginx or Apache, with a dedicated virtual host as described below.
* PHP 5.4.3+, PHP 5.6 or 7+ recommended
* ``php5-gd`` extension
* ``php5-intl`` extension
* ``php5-curl`` extension
* PHP cache (APC/OPCache) + Var cache (strongly recommended)
* MariaDB/MySQL/PostgreSQL or SQLite database (do not forget to install ``php5-xxxsql`` extension according to your database driver flavor)
* Zip/Unzip
* cUrl
* Composer
* Git

.. note::
    If you are using a *shared hosting plan*, make sure that your server’s SSH connection allows external connections. You can verify with a simple ``ping google.com``.
    If you get request timeouts, your hosting provider might be blocking your SSH connectivity.
    You should consider using at least a VPS-like hosting.
    If you really need to setup Roadiz on a simple shared-hosting plan, we encourage you to install it on your own computer and send it with SFTP/FTP (it might take a long time) or *rsync* it.

For Nginx users
^^^^^^^^^^^^^^^

If you are using Nginx, you don’t have to enable any extensions.
You only need to create your *virtual host* using our example file ``/samples/nginx.conf``.

For Apache users
^^^^^^^^^^^^^^^^

If you are using *Apache* do not forget to enable these mods:

* ``mod_rewrite``: enabling Roadiz front-controller system.
* ``mod_expires``: enabling http cache headers on static assets.

And do not use built-in ``mod_php``, prefer *PHP-FPM* 😉!

Then use ``/samples/apache.conf`` template to create your *virtual host* configuration file. It shows how to set rewrite and
secure private folders from being viewed from public visitors.

If you do not have access to your Apache virtual host configuration, you can use the built-in *htaccess* generator:

``bin/roadiz generate:htaccess``

This command will generate ``.htaccess`` files in each critical folder to enable PHP scripts or deny public access to forbidden folders.
