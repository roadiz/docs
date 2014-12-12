.. _extending_roadiz:

================
Extending Roadiz
================

It's time to see how to extend Roadiz!
As we said in the Roadiz philosophy, we don’t want any "plugin" or "module" like on another CMS.
But we can add a lot of feature using the really part that matters: Themes!

Theme powered CMS
-----------------

We wrote the Theme system to be the core of your extending experience.
You don't need to change something else than your theme. So you can use a versioning tool or backup
easily your work which will be only at one place.

You can add new entities. If so, don't forget to add your ``Entities`` namespace in Roadiz config file.
With theses additional entities, you maybe will need to create a back-office entry to manage them. It's easy!
Let's see how to.

Add back-office entry
---------------------

At first, create a controller into your theme folder, for example ``themes/MyTheme/AdminControllers/AdminController``.

Example:

.. code-block:: php

    namespace Themes\MyTheme\AdminControllers;

    class AdminController extends RozierApp
    {

        public function listAction(
            Request $request
        ) {

            $this->getService('stopwatch')->start('twigRender');

            return new Response(
                $this->getTwig()->render('admin/test.html.twig', $this->assignation),
                Response::HTTP_OK,
                array('content-type' => 'text/html')
            );
        }
    }

If you look at this exemple you can see the class extends ``RozierApp`` not your ``MyThemeApp`` class!
This will enable you to “inject” your code into Rozier Back-stage DOM and Style.

Now let's have a look to your twig template file ``admin/test.html.twig``.

.. code-block:: jinja

    {% if not head.ajax %}{% set baseTemplate = 'base.html.twig' %}{% else %}{% set baseTemplate = 'ajaxBase.html.twig' %}{% endif %}{% extends baseTemplate %}

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

The first line is for inheriting from Rozier base template.

The two next blocks are made for you to add some CSS or Javascript.
For CSS, the block ``customStyle`` can be use to link an external file with a ``<link>`` tag, the path must be something like that ``{{ request.baseUrl ~ "/themes/MyTheme/static/css/customstyle.css" }}``,  or add directly some CSS with "<style>" tag.
For JS, the block ``customScripts`` work as is, just link an external JS file or write your ``<script>`` tag.

Then create your own content, do not hesitate to give a look at Rozier back-stage theme Twig files to use the right DOM structure.
For simple features, you wouldn’t have to extend JS nor CSS if you follow the same HTML coding style.

Linking things together
-----------------------

Add the route in the theme ``route.yml`` file.

In this case the route will be:

.. code-block:: yaml

    adminTestPage:
        path:     /rz-admin/test # Setting your path behind rz-admin will activate Firewall
        defaults: { _controller: Themes\MyTheme\Controllers\AdminController::listAction }

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
            $entries['customAdmin'] = array(
                'name' => 'customAdmin',
                'path' => $c['urlGenerator']->generate('adminTestPage'),
                'icon' => 'uk-icon-cube',
                'roles' => null,
                'subentries' => null
            );

            return $entries;
        });
    }

Do not forget to add ``use Pimple\Container;`` in your file header.

``setupDependencyInjection`` method is called statically at boot time when Roadiz’s kernel is running
all available Themes to setup services. In the code above, you will extend ``backoffice.entries`` service which
define every buttons available in Rozier backstage main-menu.

If you want to have a category and sub-entries, just change the path at ``null`` value and create your ``subentries`` array as described in the next example:

.. code-block:: php

    $entries['customAdmin'] = array(
        'name' => 'customAdmin',
        'path' => null,
        'icon' => 'uk-icon-cube',
        'roles' => null,
        'subentries' => array(
            'customAdminPage' => array(
                'name' => 'customAdmin page',
                'path' => $c['urlGenerator']->generate('adminTestPage'),
                'icon' => 'uk-icon-cube',
                'roles' => null
            ),
            // Add others if you want
        )
    );

