.. _contributing:

============
Contributing
============

If you want to contribute to Roadiz project by reporting issues or hacking code, let us thank you! You are awesome!

Reporting issues
----------------

When you encounter an issue with Roadiz we would love to hear about it.
Because thanks to you, we can make the most awesome and stable CMS!
If you submit a bug report please include all informations available to you, here are some things you can do:

- Try to simplify the things you are doing until getting a minimal set of actions reproducing the problem.
- Do not forget to join a screenshot or a trace of your error.

Running tests
-----------------

If you developed a new feature or simply want to try out an installation of Roadiz you can run unit-tests.
For this you will need to install the testing framework, this can easily be done using:

.. code-block:: console

    composer update

The unit tests can be launched by the command:

.. code-block:: console

    bin/phpunit -v --bootstrap=tests/bootstrap.php tests/

If your are writing a feature, don't forget to write a unit test for it. You can find some example in the folder ``tests``.

Coding style
------------

The code you contributed to the project should respect the guidelines defined in PHP *PSR2* standard.
If you install the requirements for devs by the command ``composer update-dev``, you can use *phpcs* to check your code.
You can copy and paste the following command-lines to check easily:

.. code-block:: console

    bin/phpcs --report=full --report-file=./report.txt \
                --extensions=php --warning-severity=0 \
                --standard=PSR2 \
                --ignore=*/node_modules/*,*/.AppleDouble,*/vendor/*,*/cache/*,*/gen-src/*,*/tests/*,*/bin/* \
                -p ./

Please take those rules into account, we aim to have a clean codebase. A coherent codestyle will contribute to Roadiz stability.
Your code will be checked when we will be considering your pull requests.
