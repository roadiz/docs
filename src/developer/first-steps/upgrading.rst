.. _upgrading:

=========
Upgrading
=========

.. note::
    **Always do a database backup before upgrading.** You can use the *mysqldump* or *pg_dump* tools
    to quickly export your database as a file.

    * With a MySQL server: ``mysqldump -u[user] -p[user_password] [database_name] > dumpfilename.sql``
    * With a PostgreSQL server: ``pg_dump -U [user] [database_name] -f dumpfilename.sql``


Use *Composer* to update dependencies or Roadiz itself with *Standard* or *Headless* editions, make sure that
your Roadiz *version constraint* is set in your project ``composer.json`` file, then:

.. code-block:: bash

    composer update -o;

Run database registered migrations (some migrations will be skipped according to your database type). Doctrine
migrations are the default method to upgrade all none-node-type related entities:

.. code-block:: bash

    bin/console doctrine:migrations:migrate;

In order to avoid losing sensible node-sources data. You should
regenerate your node-source entities classes files:

.. code-block:: bash

    bin/console generate:nsentities;

Then check if there is no pending SQL changes due to your Roadiz node-types, this should be addressed with a ``doctrine:migrations:migrate``
but you can check it with:

.. code-block:: bash

    bin/console doctrine:schema:update --dump-sql;
    # Upgrade node-sources tables if necessary
    bin/console doctrine:schema:update --dump-sql --force;

Then, clear your app caches:

.. code-block:: bash

    # Clear cache for each environment
    bin/console cache:clear -e dev
    bin/console cache:clear -e prod
    bin/console cache:pool:clear cache.global_clearer
    bin/console messenger:stop-workers

.. note::
    If you are using a runtime cache like OPcache or APCu, you’ll need to purge cache manually
    because it can't be done from a CLI interface as they are shared cache engines. As a last
    chance try, you can restart your ``php-fpm`` service.


Upgrading from Roadiz v2.1 to v2.2
----------------------------------

Here is an extract for the `Changelog <https://github.com/roadiz/core-bundle-dev-app/blob/main/CHANGELOG.md#v220-2023-12-12>`_

* Doctrine migrations are now the default method to upgrade all node-type related entities.
  You should run ``bin/console doctrine:migrations:migrate`` after updating your Roadiz dependencies.
* Roadiz updated to API Platform new version and Metadata scheme. You must rewrite your api resource YAML
  files to match new scheme. See `API Platform documentation <https://api-platform.com/docs/core/upgrade-guide/>`_. You
  can remove any ``ns_**.yml`` api resource files then run ``bin/console generate:api-resources`` to generate them again. But any
  custom serialization groups will be lost.
* All node-type updates after Roadiz 2.2 will be versioned and **will generate a Doctrine migration file**. You may generate
  a Migration file with any existing node-type and add it without executing it if you want to keep a clean migration path, for
  new fresh website installs.
* ``roadiz/models`` entities path changed from ``%kernel.project_dir%/vendor/roadiz/models/src/Roadiz/Core/AbstractEntities`` to ``%kernel.project_dir%/lib/Models/src/Core/AbstractEntities``
* ``Logger`` is now handled by a different entity-manager to avoid flushing non-valid entities when persisting log entries into
  database.

.. code-block:: yaml

    orm:
        auto_generate_proxy_classes: true
        default_entity_manager: default
        entity_managers:
            # Put `logger` entity manager first to select it as default for Log entity
            logger:
                naming_strategy: doctrine.orm.naming_strategy.underscore_number_aware
                mappings:
                    ## Just sharding EM to avoid having Logs in default EM
                    ## and flushing bad entities when storing log entries.
                    RoadizCoreLogger:
                        is_bundle: false
                        type: attribute
                        dir: '%kernel.project_dir%/vendor/roadiz/core-bundle/src/Logger/Entity'
                        prefix: 'RZ\Roadiz\CoreBundle\Logger\Entity'
                        alias: RoadizCoreLogger
            default:
                dql:
                    string_functions:
                        JSON_CONTAINS: Scienta\DoctrineJsonFunctions\Query\AST\Functions\Mysql\JsonContains
                naming_strategy: doctrine.orm.naming_strategy.underscore_number_aware
                auto_mapping: true
                mappings:
                    ## Keep RoadizCoreLogger to avoid creating different migrations since we are using
                    ## the same database for both entity managers. Just sharding EM to avoid
                    ## having Logs in default EM and flushing bad entities when storing log entries.
                    RoadizCoreLogger:
                        is_bundle: false
                        type: attribute
                        dir: '%kernel.project_dir%/vendor/roadiz/core-bundle/src/Logger/Entity'
                        prefix: 'RZ\Roadiz\CoreBundle\Logger\Entity'
                        alias: RoadizCoreLogger
                    App:
                        is_bundle: false
                        type: attribute
                        dir: '%kernel.project_dir%/src/Entity'
                        prefix: 'App\Entity'
                        alias: App
	            # ...
