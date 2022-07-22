===============
Troubleshooting
===============

Empty caches manually for an environment
----------------------------------------

If you experience errors only on a dedicated environment such as
``prod``or ``dev``, it means that cache is not fresh for
these environments. As a first try, you should always call
``bin/console cache:clear;`` (replace *prod* by your environment)
in command line.

Problem with entities and Doctrine cache?
-----------------------------------------

After each Roadiz **upgrade** you should always upgrade your
node-sources entity classes and upgrade database schema.

.. code-block:: shell

    bin/console generate:nsentities;
    bin/console doctrine:schema:update --dump-sql --force;
    bin/console cache:clear;


Find help before posting an issue on Github
-------------------------------------------

Join us on Gitter: https://gitter.im/roadiz/roadiz

