===============
Troubleshooting
===============

Empty caches manually for an environment
----------------------------------------

If you experience errors only on a dedicated environment such as
``prod``, ``dev`` or ``install``, it means that cache is not fresh for
these environments. As a first try, you should always call
``bin/roadiz cache:clear -e prod;`` (replace *prod* by your environment)
in command line.

If you still get errors from a specific env and you are using an
*OPcode* cache or *var cache* (*APC*, *XCache*), call
``clear_cache.php`` entry point *from your browser* or execute
``curl http://localhost/clear_cache.php`` from your command line.

Problem with entities and Doctrine cache?
-----------------------------------------

After each Roadiz **upgrade** you should always upgrade your
node-sources entity classes and upgrade database schema.

.. code:: bash

    bin/roadiz generate:nsentities;
    bin/roadiz orm:schema-tool:update --dump-sql --force;
    bin/roadiz cache:clear -e prod;

If you are using a *OPCode var cache* like *APC*, *XCache*, you should
purge it as Roadiz stores doctrine configuration there for better
performances, call ``clear_cache.php`` entry point from your browser or
``curl http://localhost/clear_cache.php`` from your command line.

.. _reverse_proxy:

Running Roadiz behind a reverse proxy
-------------------------------------

If you are behind a reverse-proxy like *Varnish* or *Nginx proxy* on a
*Docker* environment, IP addresses, domain name and proto (https/http)
could not be correctly set. So you will have to tell Roadiz to trust
your proxy in order to use ``X_FORWARDED_*`` env vars.

Add this line to your ``index.php`` and ``preview.php`` files after
``$request = Request::createFromGlobals();`` line.

.. code:: php

    $request = Request::createFromGlobals(); // Existing line to get request
    // Trust incoming request IP as your reverse proxy
    Request::setTrustedProxies(array($request->server->get('REMOTE_ADDR')));

Roadiz uses PHP 7.1 features but I’m running on PHP 5.6 or 7.0
--------------------------------------------------------------

If you have some weird errors about `void` keywords and methods signatures that are not compatible with their parent methods, your application may use not available PHP features in your version. Usually you have dependencies which use PHP 7.1+ features such as *type hinting* or *return types*.

Roadiz is compatible with PHP 5.6 minimum, unfortunatly some of its dependencies such as *Doctrine* may be more advanced and may allow only PHP 7.1 with their latest version.

A **quick solution** should be to edit your `composer.json` file to keep compatibility with a fixed PHP version:

.. code:: json

    "config": {
        "bin-dir": "bin",
        "platform": {
            "php": "5.6.1"
        }
    }

That way, *Composer* will keep your dependencies up to date **but** it won’t use versions that don’t match your *platform* version.

Find help before posting an issue on Github
-------------------------------------------

Join us on Gitter: https://gitter.im/roadiz/roadiz

