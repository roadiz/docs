.. _download_to_vagrant:

======================================================
Download a website on my computer to work with Vagrant
======================================================

This case study is meant to get a fresh development environment from an **existing** Roadiz website and theme. Following code snippets are using
some variables data, in theses examples I’ll use:

- ``MYUSER`` as the MySQL database user.
- ``MYPASSWORD`` as the MySQL database user password.
- ``MYDATABASE`` as the MySQL database name.
- ``~/Documents/Websites`` as the working directory on your own computer.
- ``database-YYYY-mm-dd.sql`` is the mysql dump file name, replace ``YYYY-mm-dd`` with the current date.
- ``mysuperwebsite`` is your website root folder.
- ``git@github.com:johndoe/SuperTheme.git`` is an example *Github* repository for your theme.
- ``SuperTheme`` is an example theme name and folder.

On the production server:
^^^^^^^^^^^^^^^^^^^^^^^^^

1. Generate a database dump on your production server.

.. code-block:: bash

    mysqldump -uMYUSER -pMYPASSWORD MYDATABASE > database-YYYY-mm-dd.sql

Then download it on your computer. You can also use *phpmyadmin* web tool to export
your database tables. Make sure to disable *foreign key verification* and add the
*DROP IF EXISTS* directive on *phpmyadmin* export form.

On your computer:
^^^^^^^^^^^^^^^^^

1. Clone Roadiz on your favorite folder, choose well between master or develop branch if you want the stable version or the latest features.

.. code-block:: bash

    cd ~/Documents/Websites;
    # Here I choose the develop branch, because I’m warrior
    git clone -b develop https://github.com/roadiz/roadiz.git mysuperwebsite;


2. Clone your website theme in Roadiz ``themes/`` folder, choose well your branch too. If you already have a *develop* branch, clone with ``-b develop`` option.

.. code-block:: bash

    cd ~/Documents/Websites/mysuperwebsite/themes;
    # My theme already has a develop branch so…
    git clone -b develop git@github.com:johndoe/SuperTheme.git SuperTheme;

3. **[Optional]** Initialize *git-flow* on the theme. You should always work on *develop*. *Master* branch is only for releases. If you don’t have *git-flow* on your computer, you can find some help on the `official documentation <http://danielkummer.github.io/git-flow-cheatsheet/>`_.

.. code-block:: bash

    cd ~/Documents/Websites/mysuperwebsite/themes/SuperTheme;
    git flow init;
    # Git flow should checkout on develop branch for you

4. Install Roadiz’ *Composer* dependencies (after cloning the theme to be sure that all *composer* dependencies are loaded)

.. code-block:: bash

    cd ~/Documents/Websites/mysuperwebsite;
    composer install --no-dev;

5. Launch your Vagrant environment. Do not to automatically provision your VM if you want to choose what tool to install.

.. code-block:: bash

    vagrant up --no-provision;
    # ... lots of lines, bla bla bla

Choose tools to install on your VM, ``roadiz`` provisioner is mandatory… obviously, ``devtools`` provisioner will
install *Composer*, *Node.js*, *Grunt* and *Bower* commands. If you have lots of website on your computer, it’s better to
install these tools directly on your host machine, they will be more effective than on the VM. And you will be able to
take advantage of *Composer* and *NPM* cache between your dev websites.

.. code-block:: bash

    # Everything
    vagrant provision --provision-with roadiz,phpmyadmin,mailcatcher,solr,devtools
    # OR on a dev computer
    vagrant provision --provision-with roadiz,phpmyadmin,mailcatcher,solr


6. Import your database dump. First, you’ll need to copy it into your Roadiz website to make it available within your Vagrant VM. Then import it in your VM using the ``mysql`` tool.

.. code-block:: bash

    mv ~/Downloads/database-YYYY-mm-dd.sql ~/Documents/Websites/mysuperwebsite/database-YYYY-mm-dd.sql;
    cd ~/Documents/Websites/mysuperwebsite;
    # Enter your VM
    vagrant ssh;
    # Your website is located in /var/www folder
    cd /var/www;
    mysql -uroadiz -proadiz roadiz < database-YYYY-mm-dd.sql;
    # Exit your VM
    exit;

7. Update your conf/config.yml file to fill in your mysql credentials.

.. code-block:: bash

    cd ~/Documents/Websites/mysuperwebsite;
    # composer should have create a starter config file for you
    subl conf/config.yml; # If you work SublimeText

8. Use the ``bin/roadiz generate:nsentities`` to regenerate *Doctrine* entities existing in database but not as files.

.. code-block:: bash

    cd ~/Documents/Websites/mysuperwebsite;
    vagrant ssh;
    cd /var/www;
    bin/roadiz generate:nsentities;
    # You may have to check database schema if your production website is not up to
    # date with latest Roadiz
    bin/roadiz orm:schema-tool:update --dump-sql --force;

9. Download your production documents to your dev VM. You don’t have to do this within your VM.

.. code-block:: bash

    cd ~/Documents/Websites/mysuperwebsite/files;
    rsync -avcz -e "ssh -p 22" myuser@superwebsite.com:~/path/to/roadiz/files/ ./
    # do not forget ending slashes in both paths.

10. If you are using a Vagrant VM you have to add your IP address to the ``dev.php`` file to authorize your host computer to use the development environment.

11. Connect to ``http://localhost:8080/dev.php`` to begin. Every outgoing emails should be catched
by *Mailcatcher*. You can see them at address ``http://localhost:1080``.
