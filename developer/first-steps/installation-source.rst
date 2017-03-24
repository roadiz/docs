.. _installation_source:

==========================================
Install Roadiz Source Edition (deprecated)
==========================================

.. warning::
    This part is applicable for projects created prior v0.17. New projects should be created
    with Roadiz Standard Edition.

Roadiz *Source edition* can be downloaded in two different ways:

* *The Good one* — using **Git** and **Composer** (needs an *SSH* connection to your server and *Git*)
* *The Easy one* — using a bundled *Zip* archive with composer dependencies.

Using Git
---------

First you will have to setup properly your server virtual host. You can either use *Apache* or *Nginx* with Roadiz.
An example virtual host is provided in source-code for each server:

* ``samples/apache.conf``
* ``samples/nginx.conf``

You just have to customize your root path and server name. *Nginx* has built-in support
for *php-fpm* whereas *Apache* must be configured with *fastcgi* to do the same.

These example files will provide basic security configuration for private access folders:
such as ``conf`` or ``files/fonts`` folders. They will also configure your server
to redirect all non static requests to Roadiz *front-controller*.

.. note::
    **For shared hosting plan owners**, if you can’t modify your virtual host definition,
    don’t panic, Roadiz has a built-in CLI command to generate ``.htaccess`` files for you.
    Just execute ``bin/roadiz generate:htaccess`` after cloning Roadiz sources and running Composer.
    In the other hand, if you are using *Apache* and have access to your virtual host,
    we strongly recommend you to use our sample configuration and disable ``.htaccess`` files:
    performances are at their best without them.

When your HTTP server is ready to go, download *Roadiz* latest version using Git:

.. code-block:: bash

    cd your/webroot/folder;
    git clone git@github.com:roadiz/roadiz.git ./;

Use `Composer <https://getcomposer.org/doc/00-intro.md#globally>`_ to download Roadiz dependencies
and to build PHP class autolader. We even set up some post-scripts which will copy
a new ``config.yml``, ``dev.php``, ``clear_cache.php`` and ``install.php`` files for you.

.. code-block:: bash

    # Install Roadiz dependencies, prepare a fresh config file and your
    # own dev and install entry points.
    composer install --no-dev -o;

When your virtual host is ready and every files have been downloaded you can go to the
next part to access the `install environment`_.


The quick and dirty way: using a Zip archive
--------------------------------------------

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

