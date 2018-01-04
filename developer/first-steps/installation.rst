.. _installation:

===============================
Install Roadiz Standard Edition
===============================

For new projects **Roadiz** can be easily setup using ``create-project`` command.

.. code-block:: bash

    # Create a new Roadiz project
    composer create-project roadiz/standard-edition
    # Create a new theme for your project
    cd standard-edition
    bin/roadiz themes:generate --symlink --relative FooBar

*Composer* will prompt you if you want to can versioning history. Choose the default answer ``no`` as we definitely
want to replace *standard-edition* *Git* with our own versioning. Then you will be able to customize every files
in your projects and save them using Git, not only your theme. Of course we added a default ``.gitignore`` file to
prevent your configuration setting and entry points to be commited in your *Git* history. That way you can have
different configuration on development and on your production server without bothering about merge conflicts.

.. note:: 

    For *Windows* users, ``bin/roadiz themes:generate --symlink --relative FooBar`` command can be used
    without ``--relative`` option to create **absolute symlinks**. You can even install your theme assets as
    *hard copies* without ``--symlink`` option.
    Make sure that you call regularly ``bin/roadiz themes:assets:install FooBar`` when using *hard copy* mode to update
    your assets. You should use *symlinks* if possible to prevent update issues.


================================
Dealing with Roadiz environments
================================

.. _install environment:

Installation environment
------------------------

Once you’ve succedded to download Roadiz and its dependencies. You’ll have to setup its database
and every informations needed to begin your website.

As every *Symfony* applications do, *Roadiz* works using environments. By default, there is a *production*
environment which is handled by ``index.php`` entry point. At this moment, if you try to connect to
your fresh new Roadiz website, you will get an error as we did not install its database and its essential data.

To be able to use Roadiz *install interface*, you’ll need to call the *install* entry point. An ``install.php`` file
has been generated when you executed ``composer install`` command. This environment will be reachable at the Url ``http://mywebsite.com/install.php``.

For security reasons, we added an IP filtering in this entry point, you can add your own IP address in the following array: ``array('127.0.0.1', 'fe80::1', '::1', ':ffff:127.0.0.1', '::ffff:127.0.0.1')``. This IP filtering is very important if you are working on a public server, no one except you should be able to access *install* entry point.

At the end of the install process, you will be invited to remove the ``install.php`` file and to connect to your
website final URL.

Development environment
-----------------------
Roadiz *production* environment is not made for developing your own themes and extending back-office features.
As the same way as *install* environment, we prepared a *dev* environment to disable resources caching and enable
debug features. You’ll find a ``dev.php`` file at your website root which was generated at ``composer install`` command.
As well as *install.php* entry point, you’ll need to add your own IP address to filter who can access to your *dev* environment.

Preview environment
-------------------
The *preview* environment is not a real one as it only adds a flag to Roadiz’ Kernel to enable
back-office users to see unpublished nodes. By default, it is available using ``preview.php``
entry point, unless you decide to remove it.

Production environment
----------------------
This is the default ``index.php`` entry point which will be called by all your visitors.
There is no restriction on it and it will wake up Roadiz application using the strongest
caching policies. So it’s not recommended for development usage (you would have to flush caches
each time your change something in the code).

Clear cache environment
-----------------------
The *clear_cache* environment is only meant to empty Roadiz cache without waking up
the whole application. It can be useful if you are using a op-code cache like *APC* or
native PHP *OPcache*. These special caches can’t be purged from command line utilities,
so you need to call a PHP script from your browser or via ``curl`` to empty them.
Like *install* and *dev* environment, ``clear_cache.php`` is IP-restricted not to
allow everyone to flush your dear caches. You’ll need to add your own IP address to filter who can access it.

