.. _vagrant:

Using Vagrant for development
=============================

Roadiz comes with a dedicated ``Vagrantfile`` which is configured to run a *LEMP* stack
(Nginx + PHP7.0-FPM + MariaDB), a *phpMyAdmin*, a *Mailcatcher* and an *Apache Solr server*. This will be useful
to develop your website on your local computer.

Once you’ve cloned Roadiz’ sources, copy the ``samples/Vagrantfile.sample`` file as ``Vagrantfile`` at your website root.
Then do a ``vagrant up`` in Roadiz’ folder. Then `Vagrant <https://www.vagrantup.com/>`_ will run your code in ``/var/www``
and you will be able to completely use ``bin/roadiz`` commands without bloating your computer with lots of binaries.

Once vagrant VM has provisioned you will be able to use:

* ``http://192.168.33.10/install.php`` to proceed to install.
* ``http://192.168.33.10:8983/solr`` to use *Apache Solr* admin.
* ``http://192.168.33.10/phpmyadmin`` for your *MySQL* db admin.
* ``http://192.168.33.10:1080`` for your *Mailcatcher* tool.

Do not hesitate to add an entry in your ``/etc/hosts`` file to use a local *domain name*
instead of using the private IP address (eg. http://site1.dev). And for each Vagrant website, **do not forget to increment your private IP**.

.. code-block:: bash

    # /etc/hosts
    # Vagrant hosts
    192.168.33.10    site1.dev
    192.168.33.11    site2.dev
    # …

.. note::
    Be careful, **Windows users**, this ``Vagrantfile`` is configured to use a *NFS* fileshare.
    Disable it if you did not setup a *NFS* emulator. For *OS X* and *Linux* user
    this is built-in your system, so have fun!

Provisioners
------------

If you don’t need *Apache Solr* or any development tools on your *Vagrant* VM, you can
choose the ``roadiz`` provisioner which only set up the *LEMP* stack. So that you can
use *Composer* directly on your **host** machine to take benefit of *Composer* cache
if you have lots of Roadiz instances.

.. code-block:: bash

    # Just LEMP stack, no Solr, no phpMyAdmin, no Mailcatcher, no Composer, no NPM, no grunt, no bower
    vagrant up --no-provision
    vagrant provision --provision-with=roadiz

    # Just LEMP stack, no Solr, no Composer, no Mailcatcher, no NPM, no grunt, no bower
    vagrant up --no-provision
    vagrant provision --provision-with=roadiz,phpmyadmin

    # If you need Solr
    # do not use space after comma
    vagrant up --no-provision
    vagrant provision --provision-with=roadiz,solr

    # If you need dev tools
    vagrant up --no-provision
    vagrant provision --provision-with=roadiz,devtools

When you use default `vagrant up` command, it’s the same as using:

.. code-block:: bash

    # Default vagrant up provisioners
    vagrant up --no-provision
    vagrant provision --provision-with=roadiz,phpmyadmin,mailcatcher,solr,devtools

.. note::
    Pay attention that *mailcatcher* and *solr* provision scripts may take several
    minutes to run as they have to download many dependencies and compile sources for their installation.

If you already provisioned your Vagrant and you just want to add *mailcatcher* for example,
you can type ``vagrant provision --provision-with mailcatcher``. No data will
be lost in your Vagrant box unless you ``destroy`` it.

Access entry-points
-------------------

``install.php`` and ``dev.php`` entry points are IP restricted to *localhost*. To be able to use them
with a *Vagrant* setup, you’ll need to add your host machine IP to the ``$allowedIp`` array. We already
set two IP for you that should work for *forwarded* and *private* requests. Just uncomment the following lines
in these files and edit them if necessary.

.. code-block:: php

    $allowedIp = [
        '10.0.2.2',     // vagrant host (forwarded)
        '192.168.33.1', // vagrant host (private)
        '127.0.0.1', 'fe80::1', '::1' // localhost
    ];

