.. _getting-started:

===============
Getting started
===============

Roadiz is a polymorphic CMS based on a node system which can handle many type of services.
It’s based on *Symfony* components, *Doctrine ORM*, *Twig* and *Pimple* for maximum performances and security.

Roadiz node system allows you to create your data schema and to organise your content as you want.
We designed it to break technical constraints when you create tailor-made websites architectures and layouts.

For example: imagine you need to display your graphic design portfolio and… sell some t-shirts. With Roadiz you’ll be able
to create your content forms from scratch and choose the right fields you need. Images and texts for your projects.
Images, texts, prices and even geolocation for your products. That’s why it’s called *polymorphic*.

When you’ll discover Roadiz back-office interface, you’ll notice that there aren’t any Rich text editor or called
WYSIWYG editors. We made the choice to promote *Markdown* syntax in order to focus on content hierarchy and quality
instead of content style. Our guideline is to preserve and respect the webdesigners and graphic designers work.

You’ll see that we built Roadiz as webdesigners and for webdesigners. It will allow you to create really quickly website
prototypes using *Twig* templates. But as the same time you will be able to get the power of the *Symfony* and *Doctrine* core components
to build complex applications.
We want Roadiz to be a great tool for designers and developers to build strong experiences together. But we thought about editors too! Roadiz back-office theme “Rozier” has been designed to offer every back-users a great writing and administrating experience.

CMS Structure
-------------

* ``bin`` : Contains the Roadiz CLI executable
* ``cache`` : Every caches files for *Twig* templates and *SLIR* images
* ``conf`` : Your setup configuration file(s)
* ``files`` : Documents and fonts files root
* ``gen-src`` : Generated PHP code for Doctrine and your Node-types entities
* ``src`` : Roadiz CMS logic and core source code
* ``tests`` : PHP Unit tests root
* ``themes`` : Contains your themes and systems themes such as *Rozier* and *Install*
* ``vendor`` : Dependencies folder managed by *Composer*

Requirements
------------

Roadiz is a web application running with PHP. It requires an HTTP server for static assets
and SSH with out/ingoing allowed connexions.

.. note::
    If you are using a *shared hosting plan*, make sure that your server’s SSH connexion
    allows external connexions. You can verify with a simple ``ping google.com``.
    If you get request timeouts, your hosting provider might be blocking your SSH connectivity.
    You should consider using at least a VPS-like hosting.
    If you really need to setup Roadiz on a simple shared-hosting plan, we encourage you to
    make the install on your own computer and to send it with SFTP/FTP (it will be long) or *rsync* it.

Here is a short summary of mandatory elements before installing Roadiz:

* Nginx or Apache
* PHP 5.4+
* ``php5-gd`` extension
* ``php5-intl`` extension
* ``php5-imap`` extension
* ``php5-curl`` extension
* Zip/Unzip
* cUrl
* PHP cache (APC/XCache) + Var cache (strongly recommended)
* Composer
* Git

Installation
------------

You can either use *Apache* or *Nginx* with Roadiz. An example virtual host is provided for each:

* ``apache.conf``
* ``nginx.conf``

These example files will provide basic security configuration for private access folders. Such as ``conf`` or ``files/fonts`` folders.

When your HTTP server is ready to go, download *Roadiz* latest version using Git:

.. code-block:: bash

    cd your/webroot/folder;
    git clone git@github.com:roadiz/roadiz.git ./;

Use `Composer <https://getcomposer.org/doc/00-intro.md#globally>`_ to download Roadiz dependancies
and to build PHP class autolader.

.. code-block:: bash

    composer install;

.. note::
    Once your website will be ready and every node-types created you will be able to
    optimize *Composer* autoload process: ``composer dumpautoload -o``

Then copy `conf/config.default.json` file to `conf/config.json`.

.. code-block:: bash

    cp conf/config.default.json conf/config.json;

When your virtual host is ready, just go to your website to begin with the setup assistant.