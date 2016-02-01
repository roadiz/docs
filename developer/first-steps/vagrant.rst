.. _vagrant:

Using Vagrant for development
=============================

Roadiz comes with a dedicated ``Vagrantfile`` which is configured to run a *LEMP* stack
(Nginx + PHP7.0-FPM + MariaDB), a *phpMyAdmin*, a *Mailcatcher* and an *Apache Solr server*. This will be useful
to develop your website on your local computer. Once you’ve cloned Roadiz’ sources
just do a ``vagrant up`` in Roadiz’ folder. Then `Vagrant <https://www.vagrantup.com/>`_ will run your code in ``/var/www``
and you will be able to completely use ``bin/roadiz`` commands without bloating your
computer with lots of binaries.

Once vagrant VM has provisioned you will be able to use:

* ``http://localhost:8080/install.php`` to proceed to install.
* ``http://localhost:8983/solr`` to use *Apache Solr* admin.
* ``http://localhost:8080/phpmyadmin`` for your *MySQL* db admin.
* ``http://localhost:1080`` for your *Mailcatcher* tool.

.. note::
    Be careful, **Windows users**, this ``Vagrantfile`` is configured to use a *NFS* fileshare.
    Do not hesitate to disable it if you did not setup a *NFS* emulator. For *OS X* and *Linux* user
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
    vagrant provision --provision-with roadiz

    # Just LEMP stack, no Solr, no Composer, no Mailcatcher, no NPM, no grunt, no bower
    vagrant up --no-provision
    vagrant provision --provision-with roadiz,phpmyadmin

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
    vagrant provision --provision-with roadiz,phpmyadmin,mailcatcher,solr,devtools

.. note::
    Pay attention that *mailcatcher* and *solr* provision scripts may take several
    minutes to run as they have to download many dependencies and compile sources for their installation.

If you already provisioned your Vagrant and you just want to add *mailcatcher* for example,
you can type ``vagrant provision --provision-with mailcatcher``. No data will
be lost in your Vagrant box unless you ``destroy`` it.

Developing with PHP 7
---------------------

Roadiz Vagrant uses **PHP7** with its latest version published on *ppa:ondrej/php-7.0* repository.
If you do not want to use it and you prefer using PHP 5.6, you can comment out provisioner scripts in
``Vagrantfile``. This changes can’t be done once you’ve provisioned your Vagrant VM. This is applicable only for
``roadiz`` and ``mailcatcher`` scripts, others can be provisioned with both PHP versions.

.. code-block:: ruby

    # In Vagrantfile
    config.vm.provision "roadiz",       type: :shell, path: "samples/vagrant-php7-provisioning.sh"              # For PHP7
    #config.vm.provision "roadiz",      type: :shell, path: "samples/vagrant-provisioning.sh"                   # For PHP5
    config.vm.provision "mailcatcher",   type: :shell, path: "samples/vagrant-php7-mailcatcher-provisioning.sh" # For PHP7
    #config.vm.provision "mailcatcher", type: :shell, path: "samples/vagrant-mailcatcher-provisioning.sh"       # For PHP5

