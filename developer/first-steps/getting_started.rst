.. _getting-started:

===============
Getting started
===============

Roadiz is a polymorphic CMS based on a node system that can handle many types of services.
It is based on *Symfony* components, *Doctrine ORM*, *Twig* and *Pimple* for maximum performances and security.

Roadiz node system allows you to create your data schema and to organize your content as you want.
We designed it to break technical constraints when you create tailor-made websites architectures and layouts.

Imagine you need to display your graphic design portfolio and… sell some t-shirts. With Roadiz you will be able to create your content forms from scratch and choose the right fields you need. Images and texts for your projects.
Images, texts, prices and even geolocation for your products. That’s why it’s called *polymorphic*.

.. _philosophy:

Philosophy
----------

When discovering Roadiz back-office interface, you will notice that there aren’t any Rich text editor also called *WYSIWYG* editors. We made the choice to promote *Markdown* syntax in order to focus on content hierarchy and quality
instead of content style. Our guideline is to preserve and respect the webdesigners' and graphic designers' work.

You’ll see that we built Roadiz as webdesigners and for webdesigners. It will allow you to create really quickly website
prototypes using *Twig* templates. But as the same time you will be able to get the power of the *Symfony* and *Doctrine* core components
to build complex applications.

We also decided to be really strict about Plugins and other addons modules. How many of yours do not upgrade your Wordpress website because of plugin dependencies? We decided not to build Roadiz around a “Plugin” system but a **Theme system**, as every Roadiz extensions will have to serve a theme’s features. Themes will enable you to create awesome website layouts but also great back-office additions for your customers. You will be able to centralize all your custom code in one place, so you can use a versioning tool such as Git.

Roadiz theme system will allow you to daisy-chain themes and dispatch features on multiple code. As our CMS is built on Pimple dependency injection container, Roadiz can merge every available themes on the same website. For example, you will be able to create one portfolio theme using Node-system Urls and unlimited static themes which will use a static routing scheme, for a Forum or a Blog or even both! Theme system will even allow you to create additional Doctrine entities and extend our back-office. Yes, just sit on your theme code and you can extend Roadiz to create a manager for your Forum. Cherry on the cake, you can assign each theme to a specific domain name to create mobile or media specific layouts. Believe me, this cake is not a lie.

We want Roadiz to be a great tool for designers and developers to build strong web experiences together. But we thought of editors too! Roadiz back-office theme “Rozier” has been designed to offer every back-users a great writing and administrating experience.

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

Roadiz is a web application running with PHP. It requires an HTTP server for static assets and SSH with out/ingoing allowed connections.

.. note::
    If you are using a *shared hosting plan*, make sure that your server’s SSH connection allows external connections. You can verify with a simple ``ping google.com``.
    If you get request timeouts, your hosting provider might be blocking your SSH connectivity.
    You should consider using at least a VPS-like hosting.
    If you really need to setup Roadiz on a simple shared-hosting plan, we encourage you to install it on your own computer and send it with SFTP/FTP (it might take a long time) or *rsync* it.

Here is a short summary of mandatory elements before installing Roadiz:

* Nginx or Apache, with a dedicated virtual host as described below.
* PHP 5.4.3+
* ``php5-gd`` extension
* ``php5-intl`` extension
* ``php5-curl`` extension
* PHP cache (APC/XCache) + Var cache (strongly recommended)
* MariaDB/MySQL/PostgreSQL or SQLite database (do not forget to install ``php5-xxxsql`` extension according to your database driver flavor)
* Zip/Unzip
* cUrl
* Composer
* Git

For Nginx users
^^^^^^^^^^^^^^^

If you are using Nginx, you don’t have to enable any extensions.
You only need to create your *virtual host* using our example file ``/samples/nginx.conf``.

For Apache users
^^^^^^^^^^^^^^^^

If you are using *Apache* do not forget to enable these mods:

* ``mod_rewrite``: enabling Roadiz front-controller system.
* ``mod_expires``: enabling http cache headers on static assets.

And do not use built-in ``mod_php``, prefer *PHP-FPM* ;-)

Then use ``/samples/apache.conf`` template to create your *virtual host* configuration file. It shows how to set rewrite and
secure private folders from being viewed from public visitors.

Installation
------------

Roadiz can be installed in two different ways:

* The Good one : using **Git** and **Composer** (needs an SSH connnexion to your server)
* The Easy one : using a bundled Zip archive with composer dependencies.

Using Git (recommended)
^^^^^^^^^^^^^^^^^^^^^^^

First you will have to setup properly your server virtual host. You can either use *Apache* or *Nginx* with Roadiz.
An example virtual host is provided in source-code for each server:

* ``samples/apache.conf``
* ``samples/nginx.conf``

You just have to customize your root path and server name. *Nginx* has built-in support for *php-fpm* whereas *Apache* must be configured with *fastcgi* to do the same.

These example files will provide basic security configuration for private access folders:
such as ``conf`` or ``files/fonts`` folders. They will also configure your server to redirect all non static requests
to Roadiz *front-controller*.

.. note::
    **For shared hosting plan owners**, if you can’t modify your virtual host definition, don’t panic, Roadiz has a built-in CLI command to generate ``.htaccess`` files for you.
    Just execute ``bin/roadiz config --generate-htaccess`` after cloning Roadiz sources and running Composer.
    In the other hand, if you are using *Apache* and have access to your virtual host, we strongly recommend you to use our sample configuration and disable ``.htaccess`` files: performances are at their best
    without them.

When your HTTP server is ready to go, download *Roadiz* latest version using Git:

.. code-block:: bash

    cd your/webroot/folder;
    git clone git@github.com:roadiz/roadiz.git ./;

Use `Composer <https://getcomposer.org/doc/00-intro.md#globally>`_ to download Roadiz dependencies and to build PHP class autolader.

.. code-block:: bash

    composer install -n --no-dev;

Then copy `conf/config.default.yml` file to `conf/config.yml`.

.. code-block:: bash

    cp conf/config.default.yml conf/config.yml;

When your virtual host is ready, just go to your website to start with the setup assistant.

.. note::
    Once your website will be ready to be pushed to production you will be able to
    optimize *Composer* autoload process: ``composer dumpautoload -o``

The quick and dirty way: using a Zip archive
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This method must be used if you have to work on your own computer with softwares like MAMP, WAMP or
if you need to setup your website on a shared hosting plan without any SSH or Git.

If you downloaded Roadiz on the `Github release <https://github.com/roadiz/roadiz/releases>`_ page or
`directly from our website <http://www.roadiz.io>`_, you should get a bundled Zip containing every
Roadiz files and Composer dependencies. We even generated ``.htaccess`` files and a ``conf/config.yml`` file for you.

If you can unzip directly on your server, that is cool. It will save you time,
if not, just unzip it on your desktop and upload files to your server via FTP.

.. warning::
    When you transfer your Roadiz site via FTP make sure ``.htaccess`` files are copied into each important
    folders (``./``, ``./conf``, ``./src``, ``./files/fonts``, etc). If you are using an Apache setup, this will prevent
    unwanted access to important files.

Once you unzipped and moved your Roadiz files into your webserver folder, just launch the Install
tool with your Internet browser by typing your new website address. If you are working on your own computer
with MAMP, WAMP or other easy-server tool, just type ``http://localhost:8888/roadiz-folder`` in your browser (the port may change
according to your server settings).

You have to understand that using Zip archive way with FTP transfers will make updating Roadiz harder.
If you have a dedicated server or a VPS, we highly recommend you to use Git and Composer to install Roadiz. That way,
you will be able to upgrade Roadiz just by typing ``git pull origin master``.
