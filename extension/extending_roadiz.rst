.. _extending_roadiz:

================
Extending Roadiz
================

It is time to see how to extend Roadiz!
As you read in Roadiz :ref:`philosophy` part, we won’t ship "plugin" or "module" like others CMS.
But you will be able to add of lot of features using the part that really matters: Themes!

Theme powered CMS
-----------------

We coded the Theme system to be the core of your extending experience.
You don't need to change something else than your theme. So you can use a versioning tool or backup
easily your work which will be only at one place.

You can add new entities. If so, don't forget to add your ``Entities`` namespace in Roadiz config file.
With theses additional entities, you maybe will need to create a back-office entry to manage them. It's easy!
Let's see how to.

Create your own database entities
---------------------------------

You can create a theme with your own entities. Just add your *Entities* folder
to the global configuration file (``app/conf/config.yml``).

.. code-block:: yaml

    entities:
        - "../vendor/roadiz/roadiz/src/Roadiz/Core/Entities"
        - "../vendor/roadiz/models/src/Roadiz/Core/AbstractEntities"
        - "gen-src/GeneratedNodeSources"
        - "../themes/MyTheme/Entities"

Verify if everything is OK by checking migrations:

.. code-block:: bash

    bin/roadiz orm:schema-tool:update --dump-sql;

If you see your entities being created and no system database erased, just apply your migration with ``--force``.
If Doctrine send some error, you probably need to clear metadata cache:

.. code-block:: bash

    bin/roadiz cache:clear -e prod;

Clearing cache from command line **will not empty op-code cache**. Be sure to call ``clear_cache.php`` entry
point to actually clear *PHP-FPM* related caches. You can use an ``curl`` command if your website is accessible from
*localhost*:

.. code-block:: bash

    curl http://localhost/clear_cache.php;


Add back-office entry
---------------------

At first, create a controller into your theme folder, for example ``themes/MyTheme/AdminControllers/AdminController``.

Example:

.. code-block:: php

    namespace Themes\MyTheme\AdminControllers;

    use Themes\Rozier\RozierApp;
    use Themes\MyTheme\MyThemeApp;
    use Symfony\Component\HttpFoundation\Request;

    class AdminController extends RozierApp
    {
        public function listAction(
            Request $request
        ) {
            return $this->render(
                'admin/test.html.twig',
                $this->assignation,
                null,
                MyThemeApp::getThemeDir()
            );
        }
    }

If you look at this exemple you can see the class extends ``RozierApp`` not your ``MyThemeApp`` class!
This will enable you to “inject” your code into Rozier Back-stage DOM and Style. But be careful to use `MyThemeApp::getThemeDir()`
as your template namespace.

Now let's have a look to your twig template file ``admin/test.html.twig``.

.. code-block:: html+jinja

    {% extends '@Rozier/layout.html.twig' %}

    {% block customStyles %}
    <style>
        /* Custom styles here */
    </style>
    {% endblock %}

    {% block customScripts %}
    <script>
        /* Custom Stripts here */
    </script>
    {% endblock %}

    {% block content %}
    <section class="content-global add-test">
        <header class="content-header header-test header-test-edit">
            <h1 class="content-title test-add-title">{% trans %}Test admin{% endtrans %}</h1>
        </header>

        <article class="content content-test">
            <p>This page is created from MyTheme to show you how to extend backoffice features.</p>
        </article>
    </section>
    {% endblock %}

The first line is for inheriting from Rozier base template, you can notice that we explicitly choose `@Rozier` namespace.

The two next blocks are made for you to add some CSS or Javascript.
For CSS, the block ``customStyle`` can be use to link an external file with a ``<link>`` tag,
the path must be something like that ``{{ asset('static/css/customstyle.css', 'MyTheme') }}``,
or add directly some CSS with "<style>" tag.
For JS, the block ``customScripts`` work as is, just link an external JS file or write your ``<script>`` tag.

Then create your own content, do not hesitate to give a look at Rozier back-stage theme Twig files to use the right DOM structure.
For simple features, you wouldn’t have to extend JS nor CSS if you follow the same HTML coding style.

Linking things together
-----------------------

Add the route in the theme ``route.yml`` file.

In this case the route will be:

.. code-block:: yaml

    adminTestPage:
        # Setting your path behind rz-admin will activate Firewall
        path: /rz-admin/test
        defaults:
            _controller: Themes\MyTheme\AdminControllers\AdminController::listAction

Inject your own entries in back-stage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The last thing to do is to add your new admin entry in the back-office menu.

Go to your ``MyThemeApp.php`` main class and override ``setupDependencyInjection`` method,
or create it if it doesn’t exist.

.. code-block:: php

    public static function setupDependencyInjection(Container $container)
    {
        parent::setupDependencyInjection($container);

        $container->extend('backoffice.entries', function (array $entries, $c) {

            /*
             * Add a customAdmin entry in your Backoffice
             */
            $entries['customAdmin'] = [
                'name' => 'customAdmin',
                'path' => $c['urlGenerator']->generate('adminTestPage'),
                'icon' => 'uk-icon-cube',
                'roles' => null,
                'subentries' => null
            ];

            return $entries;
        });
    }

Do not forget to add ``use Pimple\Container;`` in your file header.

``setupDependencyInjection`` method is called statically at boot time when Roadiz’s kernel is running
all available Themes to setup services. In the code above, you will extend ``backoffice.entries`` service which
define every buttons available in Rozier backstage main-menu.

If you want to have a category and sub-entries, just change the path at ``null`` value and create your ``subentries`` array as described in the next example:

.. code-block:: php

    $entries['customAdmin'] = [
        'name' => 'customAdmin',
        'path' => null,
        'icon' => 'uk-icon-cube',
        'roles' => null,
        'subentries' => [
            'customAdminPage' => [
                'name' => 'customAdmin page',
                'path' => $c['urlGenerator']->generate('adminTestPage'),
                'icon' => 'uk-icon-cube',
                'roles' => null
            ],
            // Add others if you want
        ]
    ];

You can restrict buttons to users with specific roles. Just replace ``'roles' => null`` with
``'roles' => array('ROLE_ACCESS_NODES')``. You can even create your own roles to take full power of
Roadiz extension system.

.. warning::
    Adding roles in ``backoffice.entries`` service will only restrict buttons display in Rozier backstage interface.
    To really protect your controllers from unwanted users add ``$this->validateAccessForRole('ROLE_ACCESS_MY_FEATURE');`` at the first
    line of your back-ofice controller‘s actions. This will kick non-granted users from your custom back-office parts. Give a look at Rozier theme controllers to see how we use it.

