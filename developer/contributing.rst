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
-------------

If you developed a new feature or simply want to try out an installation of Roadiz you can run unit-tests.
For this you will need to install the testing dependencies, this can easily be done using:

.. code-block:: console

    composer update --dev

You have to run unit-tests on a dedicated database not to lose any existing Roadiz website. You can create a ``conf/config_test.yml`` YAML configuration which will be read only for this environment. Then, wire this configuration to a blank database.
Unit-tests can be launched by the following command:

.. code-block:: console

    bin/phpunit -v --bootstrap=tests/bootstrap.php tests/

If your are writing a feature, don't forget to write a unit test for it. You can find some example in the folder ``tests``.
In Roadiz, there are 4 types of tests:

- Standard tests which must extend ``\PHPUnit_Framework_TestCase``. These tests should only test simple logic methods and classes as they won’t require Roadiz kernel to boot up.
- Kernel dependent tests which must extend `RZ\Roadiz\Tests\KernelDependentCase``. These tests should only test logic classes and methods inside Roadiz kernel without any database concern.
- Schema dependent tests which must extend ``RZ\Roadiz\Tests\SchemaDependentCase``. These tests should only test low level database methods and classes without relying on node-types or translations. Use this type of testing if you want to test Roadiz entities and repositories methods except for Nodes and NodeTypes.
- DefaultTheme dependent tests which must extend ``RZ\Roadiz\Tests\DefaultThemeDependentCase``. These tests rely on a complete Roadiz installation with existing node-types and translation. They are longer to prepare as PHPUnit must install a fresh Roadiz with DefaultTheme at each case.

.. note::
    Each ``SchemaDependentCase`` and ``DefaultThemeDependentCase`` will provision a fresh Roadiz database then drop it. Make sure to use a dedicated database. If you execute unit-tests from an existing Roadiz website, you’ll have to run ``bin/roadiz generate:nsentities`` at the end of your testing session to build your NodesSources classes again (every environment share the same ``gen-src`` folder).

Coding style
------------

The code you contributed to the project should respect the guidelines defined in PHP *PSR2* standard.
If you install the requirements for devs by the command ``composer update --dev``, you can use *phpcs* to check your code.
You can copy and paste the following command-lines to check easily:

.. code-block:: console

    bin/phpcs --report=full --report-file=./report.txt \
                --extensions=php --warning-severity=0 \
                --standard=PSR2 \
                --ignore="*/node_modules/*,*/.AppleDouble,*/vendor/*,*/cache/*,*/gen-src/*,*/tests/*,*/bin/*" \
                -p ./

Or you can use *phpcbf* to automatically fix code style issues.

.. code-block:: console

    bin/phpcbf --report=full --report-file=./report.txt \
                --extensions=php --warning-severity=0 \
                --standard=PSR2 \
                --ignore="*/node_modules/*,*/.AppleDouble,*/vendor/*,*/cache/*,*/gen-src/*,*/tests/*,*/bin/*" \
                -p ./

Please take those rules into account, we aim to have a clean codebase. A coherent codestyle will contribute to Roadiz stability.
Your code will be checked when we will be considering your pull requests.
