.. _installation_on_shared_hosting:

==========================================
Install Standard Edition on shared hosting
==========================================

**… without SSH commands and FTP 🤢.**

Modern CMS built on *Composer* and *CLI* commands can't be deployed easily on
shared hosting environments on which only FTP is available. Here are some handy
tools to deploy a *Roadiz* with FTP.

The first condition is that you'll have to setup a local environment which will
be mirrored to your shared hosting FTP, ``vendor/`` included… yes. Grab a very long cup of coffee
when you initiate the first FTP push, it will be long, very long. Next pushes will
only push newer files.

The second condition is that you must create all your node-type entities on
your local env first to be able to mirror all ``GeneratedNodeSources\*`` classes
as you won't be able to generate them on your production env.

Prepare your local env with Makefile
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Standard-edition* comes with a sample ``Makefile`` so you can write a ``push-prod``
recipe to automatize all process using ``lftp`` command. Make sure it’s installed on your
computer:

.. code-block:: bash

    # macOS
    brew install lftp
    # Ubuntu/Debian
    apt-get install lftp
    # …

This recipe will clear your cache files, generate Apache ``.htaccess`` files, copy your theme assets as real files,
mirror all necessary files without all exceptions (list can be improved) then copy your theme assets
back to symlinks.

.. code-block:: makefile

    push-prod:
        make cache
        bin/roadiz generate:htaccess
        bin/roadiz themes:assets:install ${THEME_PREFIX}
        lftp -e "mirror --only-newer --parallel=3 -R \
            --exclude '/\..+/$$' \
            -x 'app/conf/config\.yml' \
            -x '\.env' \
            -x '(README\.md|Makefile|Dockerfile|Vagrantfile)' \
            -x '(bin|docker|samples|tmp|\.git|\.idea|files)/' \
            -x 'app/(cache|logs|sessions|tmp)/' \
            -x 'web/files/' \
            -x 'node_modules/' \
            -x 'bower_components/' \
            -x 'themes/${THEME}/(app|node_modules|webpack)/' \
            -x '\.(psd|rev|log|cmd|bat|pif|scr|exe|c?sh|reg|vb?|ws?|sql|db)$$' \
            ./ ${FTP_REMOTE_PATH}" -u ${FTP_USER},${FTP_PASS} ${FTP_HOST}
        bin/roadiz themes:assets:install --relative --symlink ${THEME_PREFIX}

Make sure your configuration matches your shared hosting plan, for example, adjust
your cache driver to ``file``, ``php`` to get decent performances.

.. code-block:: yaml

    cacheDriver:
        type: file
        host: null
        port: null
