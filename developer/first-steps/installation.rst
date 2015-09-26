.. _installation:

============
Installation
============

Download sources
----------------

Roadiz can be downloaded in two different ways:

* *The Good one*: using **Git** and **Composer** (needs an SSH connnexion to your server)
* *The Easy one*: using a bundled Zip archive with composer dependencies.

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

When your virtual host is ready and every files have been downloaded you can go to the
next part to enable the `install environment`_.

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
If you have a dedicated server or a VPS, we highly recommend you to use *Git* and *Composer* to install Roadiz. That way,
you will be able to upgrade Roadiz just by typing ``git pull origin master``.


Dealing with Roadiz environments
--------------------------------

.. _install environment:

Installation environment
^^^^^^^^^^^^^^^^^^^^^^^^

Once you’ve succedded to download Roadiz sources and dependencies. You’ll have to setup its database
and every informations needed to begin your website.

As every *Symfony* application do, Roadiz works using environments. By default, there is a *production*
environment which is handled by ``index.php`` entry point. At this moment, if you try to connect to
your fresh new Roadiz website, you will get an error as we did not install its database and its essential data.

To be able to use Roadiz *install interface*, you’ll need to copy ``samples/install.php.sample`` to ``install.php``. This will enable
a new environment called *install* reachable at the Url ``http://mywebsite.com/install.php``. For security reasons, we added an IP filtering in
this entry point, you can add your own IP address in the following array: ``array('127.0.0.1', 'fe80::1', '::1')``.
This IP filtering is very important if you are working on a public server, no one except you should be able to access
*install* entry point.

.. note::
    For those who downloaded Roadiz using the Zip archive, an ``install.php`` file should be already available
    in your website folder, just edit it to add you own IP address(es).

At the end of the install process, you will be invited to remove the ``install.php`` file and to connect to your
website final URL.

Development environment
^^^^^^^^^^^^^^^^^^^^^^^

Roadiz *production* environment is not made for developing your own themes and extending back-office features.
As the same way as *install* environment, we prepared a *dev* environment to disable resources caching and enable
debug features. Just copy ``samples/dev.php.sample`` to ``dev.php``, and like *install* entry point, you’ll need
to add your own IP address to filter who can access to your *dev* environment.

.. note::
    For those who downloaded Roadiz using the Zip archive, an ``dev.php`` file should be already available
    in your website folder, just edit it to add you own IP address(es).

Preview environment
^^^^^^^^^^^^^^^^^^^

The *preview* environment is not a real one as it only adds a flag to Roadiz’ Kernel to enable
back-office users to see unpublished nodes. By default, it is available using ``preview.php``
entry point, unless you decide to remove it.

