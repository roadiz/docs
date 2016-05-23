.. _moving:

Moving a website to another server
==================================

Before moving your website, make sure you have backed up your data:

* Dump your database, using ``mysqldump`` or ``pg_dump`` tools.
* Archive your ``files/`` folder, it contains all your documents and font files.

Moving to a SSH+Git hosting plan or an other development machine
----------------------------------------------------------------

From this point you can install your new webserver, as described in :ref:`Install section <installation>`.
Pay attention that if your theme needs some additionnal *composer* dependencies you should
*clone/copy* it into your *themes/* folder **before** running ``composer install --no-dev``. That way
*composer* will download theme libraries at the same time as Roadiz’ ones (:ref:`See how to use Composer in your themes <theme_composer>`).

Then import your dump and files into your new server.

Once you’ve imported your database, you must edit manually your `conf/config.yml`,
you can reuse the former server’s one and adapt its database credentials.

.. warning::
    **Do not perform any schema update if no gen-src\\GeneratedNodeSources classes is available**,
    it will erase your NodesSources data as their entities files haven’t been generated yet.

When you have edited your ``conf/config.yml`` file, regenerate your *Doctrine* entities class files:

.. code-block:: bash

    bin/roadiz generate:nsentities;

Now you can perform a schema update without losing your nodes data:

.. code-block:: bash

    bin/roadiz orm:schema-tool:update --dump-sql;
    bin/roadiz orm:schema-tool:update --force;
    bin/roadiz cache:clear -e prod

.. note::
    If you are using an OPcode cache like XCache or APC, you’ll need to purge cache manually
    because it can't be done from a CLI interface as they are shared cache engines. The most
    effective way is to restart your *PHP-FPM* service or *Apache* if your are using *mod_php*.

Synchronize documents and fonts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can move your ``files/`` folder using SFTP but the best way is to use ``rsync`` command
as it will upload only newer files and it is much faster.

.. code-block:: bash

    # This will synchronize files on your production server from your local Roadiz setup.
    # Do not forget ending slash after each path!
    rsync -avcz -e "ssh -p 22" /path/to/roadiz/files/ user@my-prod-server.com:/path/to/roadiz/files/

It works in the other way too. If you want to work on your local copy with up to date files and
fonts, you can download actual files from the production website:

.. code-block:: bash

    # This will synchronize files on your local development server from your production server.
    # Do not forget ending slash after each path!
    rsync -avcz -e "ssh -p 22" user@my-prod-server.com:/path/to/roadiz/files/ /path/to/roadiz/files/


Moving to a non-SSH hosting plan
--------------------------------

You have nearly finished your brand new website using Roadiz. You have been working on your own
server using Git and Composer, up to this point everthing went well.

Now you have to push to production, but your prod-server has no SSH connection. You are stuck with
an SFTP connection or worst, an old FTP one. Don’t panic, it will take a little more time but it is still possible.

.. warning::
    Many shared-plan hosters offer you only one or two databases. When moving a Roadiz website, make sure
    that your database is empty and do not contain orphan tables, you must respect the rule “One app = One database”.

.. note::
    If you can ZIP on your production server or if you are going to push your files via FTP,
    do not forget to exclude ``.git`` and ``node_modules`` folders! These folders have **lots** of useless files
    for a production SSH-less environnement.
    Here is a sample ZIP command to exclude them:
    ``zip -r mywebsite.zip mywebsite/ -x "mywebsite/.git/*" "mywebsite/themes/**/static/node_modules/*"``.

* Before transfering your website, make sure you have ``.htaccess`` file in every sensitive folders. You can use the ``bin/roadiz generate:htaccess`` on your computer.
* If you have at least SFTP, you should have to rights to zip/unzip on your distant server. So zip the whole Roadiz folder.
* If you only have FTP, you must be prepared to transfer your Roadiz folder, file-by-file. Just get yourself a nice cup of coffee.
* Once everything is copied on your production server, verify than you have the same files as on your dev-server.
* Import your database dump with phpmyadmin or pgmyadmin.
* Edit your ``conf/config.yml`` to match your new database credentials.
* Verify that root ``.htaccess`` file contains every informations to enable Apache url-rewriting.
* Try to connect to your website
* If it doesn’t work or display anything, read your PHP log file to understand where the problem comes from. It might be your database credentials or an oudated PHP version. Check that your hoster has installed every needed PHP extensions, see :ref:`requirements`.
