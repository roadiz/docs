.. _extending_roadiz:

================
Extending Roadiz
================

It's time to see how to extend Roadiz!
As we said in the Roadiz philosophy, we dont want to have "plugin" or "module" like on another CMS.
But we can add a lot of feature by theme!

Theme powered CMS
-----------------

We write the theme system to be the core of your extending experience.
You don't need to change something else than your theme.

You can add new entities. if you do, don't forget to add the namespace in the roadiz config file.
With theses entities, you want maybe to create a back-office entry to manage them. It's easy!
Let's see how to do.

Add back-office entry
---------------------

At first create a controller into your theme folder.

Example:

.. code-block:: php

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

If you look at this exemple you can see the class extends RozierApp. This is made for keep the rozier back-office DOM and style.

Now let's have a look to the twig file.

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
            <p>This page is created from DefaultTheme to show you how to extend backoffice features.</p>
        </article>
    </section>
    {% endblock %}

The first line is for set the base template.

The two next blocks are made for you to add some css or javascript.
For css, the block "customStyle": you css file with a balise "<link>", for the path that must be something like that ``{{ request.baseUrl ~ "/themes/YourTheme/static/css/customstyle.css" }}``,  or add some css in "<style>" balise.
For js, the block "customScripts": work like "customStyle" block.

The end of the file is just test content.

Add the route in the theme route file.

In this case the route will be:

.. code-block:: yaml

    adminTestPage:
        path:     /rz-admin/test # Setting your path behind rz-admin will activate Firewall
        defaults: { _controller: Themes\YourTheme\Controllers\AdminController::listAction }

And now the last thing at the information in the back-office menu.

Go to your YourThemeApp.

And add in the class, if it doesn't existe, this function:

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

Don't forget to add ``use Pimple\Container;``!

The important thing inside is the add entries. This will define your entry in the back-office menu.

If you want to have a category and subentries, just change the path at ``null`` value and add in ``subentries`` like the next example.

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
