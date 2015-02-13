.. _moving:

Moving a website to another server
==================================

Before moving your website, make sure you have backed up your data:

* Dump your database, using ``mysqldump`` or ``pg_dump`` tools.
* Archive your ``files/`` folder, it contains all your documents and font files.

Moving to a SSH+Git hosting plan
--------------------------------

From this point you can install your new webserver, as described in :ref:`Install section <getting-started>`.

Then import your dump and files into your new server.

Once you’ve imported your database, you must edit manually your `conf/config.json`,
you can reuse the former server’s one and adapt its database credentials.

.. warning::
    **Do not perform any schema update if no *gen-src\\GeneratedNodeSources* classes is available**,
    it will erase your NodesSources data as their entities files haven’t been generated yet.

When you’ve edited your ``conf/config.json`` file, regenerate your entities source files

.. code-block:: bash

    bin/roadiz core:node-types --regenerateAllEntities;

Now you can perform a schema update without losing your nodes data

.. code-block:: bash

    bin/roadiz orm:schema-tool:update --dump-sql;
    bin/roadiz orm:schema-tool:update --force;

    bin/roadiz cache --clear-all

.. note::
    If you are using an OPcode cache like XCache or APC, you’ll need to purge cache manually
    because it cannot done from a CLI interface as they are shared cache engines.

Synchronize documents and fonts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can move your ``files/`` folder using SFTP but the best way is to use ``rsync`` command
as it will upload only newer files and it’s so much faster!

.. code-block:: bash

    # This will synchronize files on your production server from your local Roadiz setup.
    # Do not forget ending slash after each path!
    rsync -avcz -e "ssh -p 22" /path/to/roadiz/files/ user@my-prod-server.com:/path/to/roadiz/files/



Moving to a non-SSH hosting plan
--------------------------------

You have nearly finished your brand new website using Roadiz. You’ve worked on your own
server using Git and Composer, up to this point everthing went well.

Now you have to push to production, but your prod-server has no SSH connection. You are stuck with
your SFTP connection or worst, an old FTP one. Don’t panic, it will take a little more time but it’s still possible.

.. warning::
    Many shared-plan hosters offer you only one or two databases. When moving a Roadiz website, make sure
    that your database is empty and do not contain orphan tables, you must respect the rule “One app = One database”.

* Do not forget to generate ``.htaccess`` files for your prod server. Type ``bin/roadiz config --generateHtaccess``.
* If you have at least SFTP, you should have to rights to zip/unzip on your distant server. So zip the whole Roadiz folder.

.. note::
    If you can ZIP on your production server or if you are going to push your files via FTP,
    do not forget to exclude ``.git`` and ``node_modules`` folders! These folders have **lots** of useless files
    for a production SSH-less environnement.
    Here is a sample ZIP command to exclude them: ``zip -r mywebsite.zip mywebsite/ -x "mywebsite/.git/*" "mywebsite/themes/**/static/node_modules/*"``.

* If you only have FTP, you must be prepared to transfer your Roadiz folder, file-by-file. Just go get a cup of coffee.
* Once everything is copied on your production server, verify than you have the same files as on your dev-server.
* Import your database dump with phpmyadmin or pgmyadmin.
* Edit your ``conf/config.json`` to match your new database credentials. Enable ``devMode`` manually.
* Verify that every sensitive folders contain an ``.htaccess`` file to deny access. Verify that root ``.htaccess`` file contains every informations to enable Apache url-rewriting.
* Try to connect to your website, if everything works disable ``devMode`` and enjoy your hard work.
* If it doesn’t work or display anything, read your PHP log file to understand where does the problem come from. It might be your database credentials or you PHP version that is too low. Check that your hoster has installed every needed PHP extensions, see :ref:`requirements`.
