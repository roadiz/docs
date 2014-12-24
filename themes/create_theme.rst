.. _create-theme:

================
Creating a theme
================

Roadiz themes are one of the main parts of the CMS. They allow you to create your really personnal website.
You can duplicate an existing theme to customize stylesheets and images. Or you can start from ground and build
your very own theme using our API. Every visible part of Roadiz is a theme. Even backoffice interface is a theme, and it’s called *Rozier* according to the street name where REZO ZERO created it.

Each theme is a folder which must be placed in ``themes/`` folder. Roadiz comes with 3 default themes :

- *Install* : It’s the first page theme you see when you launch Roadiz in your browser for the first time.
- *Rozier* : Here is the REZO ZERO designed backoffice for Roadiz, it’s available from ``rz-admin/`` url and protected by firewall.
- *DefaultTheme* : It’s… the default theme which can be copied to start your own themes.

As these 3 themes come bundled with Roadiz, you can’t edit or update their files. Your changes would be overrode
the next time you update Roadiz via Git or direct download. If you want to create your own Backoffice, you can. Just name it differently and hook it in backoffice or using CLI commands.

Preparing your own frontend theme
---------------------------------

First copy ``DefaultTheme`` folder and rename it against your new theme. Keep in mind that *DefaultTheme*
folder will be overrode at each CMS updates, so don’t update its files or you’ll suffer of losing precious
data. And we don’t want you to be mad at us.

So once you duplicated and renamed *DefaultTheme* with your own sweet name, do not forget to rename every references in:

* **Folder name** and **Class namespace** must be the same (Ex: “MyAwesomeTheme”) for making autoloader works with your theme.
* **Theme entry point class**: your main theme class must be named after your folder name plus ``App`` suffix (Ex: “MyAwesomeThemeApp.php”)
* **Resources/routes.yml**: rename every route class path using your namespace:

.. code-block:: yaml

    # This route is required!
    homePage:
        path:     /
        defaults: { _controller: Themes\MyAwesomeTheme\MyAwesomeThemeApp::homeAction }
    homePageLocale:
        path:     /{_locale}
        defaults: { _controller: Themes\MyAwesomeTheme\MyAwesomeThemeApp::homeAction }
        requirements:
            # Use every 2 letter codes
            _locale: "[a-z]{2}"

    contactPage:
        path:     /contact
        defaults: { _controller: Themes\MyAwesomeTheme\Controllers\ContactController::indexAction }
    contactPageLocale:
        path:     /{_locale}/contact
        defaults: { _controller: Themes\MyAwesomeTheme\Controllers\ContactController::indexAction }
        requirements:
            # Use every 2 letter codes
            _locale: "[a-z]{2}"

    feedRSS:
        path:     /feed
        defaults: { _controller: Themes\MyAwesomeTheme\Controllers\FeedController::indexAction }
    sitemap:
        path:     /sitemap.xml
        defaults: { _controller: Themes\MyAwesomeTheme\Controllers\SitemapController::indexAction }
    defaultRemoveTrailingSlash:
        path: /{url}
        defaults: { _controller: Themes\MyAwesomeTheme\MyAwesomeThemeApp::removeTrailingSlashAction }
        requirements:
            url: .*/$
        methods: [GET]


* Create your own ``config.json`` file, this file is needed by Roadiz to parse correctly your theme
when you will add it to the backoffice. If your theme does not show up, you may check this JSON file
syntax:

.. code-block:: json

    {
        "name": "My awesome theme",
        "author": "Ambroise Maupate",
        "copyright": "REZO ZERO",
        "themeDir": "MyAwesomeTheme",
        "supportedLocale": ["en"],
        "versionRequire": "1.0.0",
        "importFiles": {
            "roles": [],
            "groups": [],
            "settings": [],
            "nodetypes": [],
            "tags": [],
            "nodes": []
        }
    }

* Edit your main class informations (``MyAwesomeThemeApp.php``)

.. code-block:: php
   :linenos:
   :emphasize-lines: 11,25,30,34,38,42

    /*
     * Copyright REZO ZERO 2014
     *
     * Description
     *
     * @file MyAwesomeThemeApp.php
     * @copyright REZO ZERO 2014
     * @author Ambroise Maupate
     */

    namespace Themes\MyAwesomeTheme;

    use RZ\Roadiz\CMS\Controllers\FrontendController;
    use RZ\Roadiz\Core\Kernel;
    use RZ\Roadiz\Core\Entities\Node;
    use RZ\Roadiz\Core\Entities\Translation;
    use RZ\Roadiz\Core\Utils\StringHandler;

    use Symfony\Component\HttpFoundation\Request;
    use Symfony\Component\HttpFoundation\Response;
    use Symfony\Component\Routing\Exception\ResourceNotFoundException;
    /**
     * MyAwesomeThemeApp class
     */
    class MyAwesomeThemeApp extends FrontendController
    {
        /**
         * {@inheritdoc}
         */
        protected static $themeName =      'My awesome theme';
        /**
         * {@inheritdoc}
         */
        protected static $themeAuthor =    'Ambroise Maupate';
        /**
         * {@inheritdoc}
         */
        protected static $themeCopyright = 'REZO ZERO';
        /**
         * {@inheritdoc}
         */
        protected static $themeDir =       'MyAwesomeTheme';
        /**
         * {@inheritdoc}
         */
        protected static $backendTheme =    false;

        …
    }

Then you will be able to add your fresh new theme into Roadiz backoffice.

*We are planning a simple command-line tool that will ease up this process.*

Static routing
--------------

Before searching for a node’s Url (Dynamic routing), Roadiz will parse your theme ``route.yml``
to find static controllers and actions to execute.
Static actions just have to comply with the ``Request`` / ``Response`` scheme.
It is adviced to add ``$_locale`` and ``$_route`` optional arguments to better handle
multilingual pages.

.. code-block:: yaml

    foo:
        path:     /foo
        defaults: { _controller: Themes\MyAwesomeTheme\Controllers\FooBarController::fooAction }
    bar:
        path:     /{_locale}/bar
        defaults: { _controller: Themes\MyAwesomeTheme\Controllers\FooBarController::barAction }
        requirements:
            # Use every 2 letter codes
            _locale: "[a-z]{2}"


.. code-block:: php

    public function fooAction(Request $request) {

        $translation = $this->bindLocaleFromRoute($request, 'en');
        $this->prepareThemeAssignation(null, $translation);

        return new Response(
            $this->getTwig()->render('foo.html.twig', $this->assignation),
            Response::HTTP_OK,
            array('content-type' => 'text/html')
        );
    }

    public function barAction(
        Request $request,
        $_locale = null,
        $_route = null
    ) {
        $translation = $this->bindLocaleFromRoute($request, $_locale);
        $this->prepareThemeAssignation(null, $translation);


        return new Response(
            $this->getTwig()->render('bar.html.twig', $this->assignation),
            Response::HTTP_OK,
            array('content-type' => 'text/html')
        );
    }

.. _dynamic-routing:

Dynamic routing
---------------

.. Note::

    Every node-types will be handled by a specific ``Controller``.
    If your created a “Page” type, Roadiz will search for a ``…\\Controllers\\PageController`` class and
    it will try to execute the ``indexAction`` method.

An indexAction method must comply with the following signature.
It will take the HttpFoundation’s Request as first then a ``Node`` and a ``Translation`` instances.
These two last arguments will be useful to generate your page information and to
render your current node.

.. code-block:: php

    /**
     * Default action for any Page node.
     *
     * @param Symfony\Component\HttpFoundation\Request $request
     * @param RZ\Roadiz\Core\Entities\Node              $node
     * @param RZ\Roadiz\Core\Entities\Translation       $translation
     *
     * @return Symfony\Component\HttpFoundation\Response
     */
    public function indexAction(
        Request $request,
        Node $node = null,
        Translation $translation = null
    ) {
        $this->prepareThemeAssignation($node, $translation);

        $this->getService('stopwatch')->start('twigRender');

        return new Response(
            $this->getTwig()->render('types/page.html.twig', $this->assignation),
            Response::HTTP_OK,
            array('content-type' => 'text/html')
        );
    }

As *Symfony* controllers do, every Roadiz controllers actions have to return a valid ``Response`` object.

Home page case
--------------

Homepage is always a special page to handle. With Roadiz you have the choice to handle it as
a static page or as a dynamic page. In both case you’ll need to setup a static route
in your theme ``Resources/routes.yml`` file.

.. code-block:: yaml

    homePage:
        path:     /
        defaults: { _controller: Themes\MyAwesomeTheme\MyAwesomeThemeApp::homeAction }
    homePageLocale:
        path:     /{_locale}
        defaults: { _controller: Themes\MyAwesomeTheme\MyAwesomeThemeApp::homeAction }
        requirements:
            # Use every 2 letter codes
            _locale: "[a-z]{2}"

Now you can code your ``homeAction`` method in ``MyAwesomeThemeApp`` class. It will need 2 arguments:

- A ``Request`` object: ``$request``
- An optional locale string variable ``$_locale = null``

Dynamic home
^^^^^^^^^^^^

If your home page is built with a node. You can tell Roadiz to handle home request as
a *Page* request (if your home is a *page* type node) using ``$this->handle($request);`` method.
This method will use the ``PageController`` class and ``page.html.twig`` template to render your home.
This can be useful when you need to switch your home page to an other page, there is no need to make
special ajustments.

.. code-block:: php

    /**
     * {@inheritdoc}
     */
    public function homeAction(
        Request $request,
        $_locale = null
    ) {
        /*
         * Get language from static route
         */
        $translation = $this->bindLocaleFromRoute($request, $_locale);
        $home = $this->getService('em')->getRepository('RZ\Roadiz\Core\Entities\Node')
                                       ->findHomeWithTranslation($translation);

        $this->prepareThemeAssignation($home, $translation);

        /*
         * Render Homepage according to its node-type controller
         */
        return $this->handle($request);
    }

Static home
^^^^^^^^^^^

Imagine now that your home page has a totally different look than other pages. Instead of letting
``handle()`` method returning your Response object, you can create it directly and use a dedicated
``home.html.twig`` template.

.. code-block:: php

    /**
     * {@inheritdoc}
     */
    public function homeAction(
        Request $request,
        $_locale = null
    ) {
        /*
         * Get language from static route
         */
        $translation = $this->bindLocaleFromRoute($request, $_locale);
        $home = $this->getService('em')->getRepository('RZ\Roadiz\Core\Entities\Node')
                                       ->findHomeWithTranslation($translation);

        $this->prepareThemeAssignation($home, $translation);

        /*
         * Render Homepage manually
         */
        return new Response(
            $this->getTwig()->render('home.html.twig', $this->assignation),
            Response::HTTP_OK,
            array('content-type' => 'text/html')
        );
    }

Keep in ming that ``prepareThemeAssignation`` method will assign for you some useful variables no matter you choice
a dynamic or a static home handling:

- ``node``
- ``nodeSource``
- ``translation``


