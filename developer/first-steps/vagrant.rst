.. _vagrant:

Using Vagrant for development
=============================

Roadiz comes with a dedicated ``Vagrantfile`` which is configured to run a *LEMP* stack
(Nginx + PHP-FPM + MariaDB) and an *Apache Solr server*. This will be useful
to develop your website on your local computer. Once you’ve cloned Roadiz’ sources
just do a ``vagrant up`` in Roadiz’ folder. Then `Vagrant <https://www.vagrantup.com/>`_ will run your code in ``/var/www``
and you will be able to completely use ``bin/roadiz`` commands without bloating your
computer with lots of binaries.

Once vagrant VM has provisioned you will be able to use:

* ``http://localhost:8080/install.php`` to proceed to install.
* ``http://localhost:8983/solr`` to use *Apache Solr* admin.
* ``http://localhost:8080/phpmyadmin`` for your *MySQL* db admin.

.. note::
    Be careful, **Windows users**, this ``Vagrantfile`` is configured to use a *NFS* fileshare.
    Do not hesitate to disable it if you did not setup a *NFS* emulator. For *OS X* and *Linux* user
    this is built-in your system, so have fun!

Provisioners
------------

If you don’t need *Apache Solr* or any development tools on your *Vagrant* VM, you can
choose the ``roadiz`` provisioner which only set up the *LEMP* stack. So that you can
use *Composer* directly on your host machine to take benefit of your cache
if you have lots of Roadiz websites.

.. code-block:: bash

    # Just LEMP stack, no Solr, no Composer, no NPM, no grunt, no bower
    vagrant up --no-provision
    vagrant provision --provision-with roadiz

    # If you need Solr
    # do not use space after comma
    vagrant up --no-provision
    vagrant provision --provision-with roadiz,solr

    # If you need dev tools
    vagrant up --no-provision
    vagrant provision --provision-with roadiz,devtools

When you use default `vagrant up` command, it’s the same as using:

.. code-block:: bash

    # Default vagrant up provisioners
    vagrant up --no-provision
    vagrant provision --provision-with roadiz,solr,devtools


