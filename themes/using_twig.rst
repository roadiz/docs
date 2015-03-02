.. _using-twig:

==========
Using Twig
==========

.. Note::

    Twig is the default rendering engine for *Roadiz* CMS. You’ll find its documentation at http://twig.sensiolabs.org/doc/templates.html

When you use :ref:`Dynamic routing <dynamic-routing>` within your theme, Roadiz will automatically assign some variables for you.

* **request** — [object] Symfony request object which contains useful data such as current URI or GET parameters
* **head**
    * **ajax** — [boolean] Tells if current request is an Ajax one
    * **cmsVersion** — [string]
    * cmsVersionNumber
    * **cmsBuild** — [string]
    * **devMode** — [boolean]
    * **baseUrl** — [string] Server base Url. Basically your domain name, port and folder if you didn’t setup Roadiz at you server root
    * **filesUrl** — [string]
    * **resourcesUrl** — [string] Your theme ``Resources`` url. Useful to reach your assets.
    * **ajaxToken** — [string]
    * **universalAnalyticsId** — [string]
    * **useCdn** - [boolean]
    * **fontToken** — [string]
* **session**
    * **messages** — [array]
    * **id** — [string]
    * **user** — [object]
* **securityContext** — [object] This object is required when you browse nodes not to display unpublished content for anonymous visitors

There are some more content only available from *FrontendControllers*.

* **_default_locale** — [string]
* **meta**
    * **siteName** — [string]
    * **siteCopyright** — [string]
    * **siteDescription** — [string]

Then, in each dynamic routing *actions* you will need this line ``$this->storeNodeAndTranslation($node, $translation);``
in order to make page content available from your Twig template.

* **node** — [object]
* **nodeSource** — [object]
* **translation** — [object]
* **pageMeta**
    * **title** — [string]
    * **description** — [string]
    * **keywords** — [string]

All these data will be available in your Twig template using ``{{ }}`` syntax.
For example use ``{{ pageMeta.title }}`` inside your head’s ``<title>`` tag.
You can of course call objects members within Twig using the *dot* separator.

.. code-block:: html+jinja

    <article>
        <h1><a href="{{ nodeSource.handler.url }}">{{ nodeSource.title }}</a></h1>
        <div>{{ nodeSource.content|markdown }}</div>

        {# Use complex syntax to grab documents #}
        {% set images = nodeSource.handler.documentsFromFieldName('images') %}
        {# or Shortcut syntax #}
        {% set images = nodeSource.images %}

        {% for image in images %}

            {% set imageMetas = image.documentTranslations.first %}
            <figure>
                {{ image.viewer.getDocumentByArray({ 'width':200 })|raw }}
                <figcaption>{{ imageMetas.name }} — {{ imageMetas.copyright }}</figcaption>
            </figure>
        {% endfor %}
    </article>

Handling node-sources with Twig
-------------------------------

Most of frontent work will consist in Twig templating and Twig assignations. Roadiz Core entities are already
linked together not to prepare your data before rendering it. Basically, you can access nodes or nodeSources data
directly in Twig using the “dot” seperator.

There is even some magic about Twig when accessing private or protected fields:
just write the fieldname and it will use the field getter: ``{{ nodeSource.content|markdown }}`` will be interpreted as
``{{ nodeSource.getContent|markdown }}`` by Twig. It can be a time and space saver to just use fieldnames.

.. note::
    Roadiz will camelize your node-type fields names to create getters and setters into you NS class.
    So if you created a ``header_image`` field, getter will be named ``getHeaderImage()``.
    However, if you called it ``headerimage``, getter will be ``getHeaderimage()``

You can access methods too! You will certainly need to get a nodeSources documents to display them. Instead of assigning each document
in your PHP Controller before, you can directly use them in Twig:

.. code-block:: html+jinja

    {% set images = nodeSource.images %}

    {% for image in images %}

        {% set imageMetas = image.documentTranslations.first %}
        <figure>
            {{ image.viewer.documentByArray({ 'width':200 })|raw }}
            <figcaption>{{ imageMetas.name }} — {{ imageMetas.copyright }}</figcaption>
        </figure>
    {% endfor %}

Loop over node-source children
------------------------------

With Roadiz you will be able to grab each node-source children.

.. code-block:: html+jinja

    {% set childrenBlocks = nodeSource.handler.children(null, null, securityContext) %}
    {% for childBlock in childrenBlocks %}
    <div class="block">
        <h2>{{ childBlock.title }}</h2>
        <div>{{ childBlock.content|markdown }}</div>
    </div>
    {% endfor %}

`getChildren method <http://api.roadiz.io/RZ/Roadiz/Core/Handlers/NodesSourcesHandler.html#method_getChildren>`_ must be called with a valid ``SecurityContext`` instance if you **don’t want anonymous visitors to see unpublished contents**. Its first parameters can be set to filter over children and override default ordering.

.. code-block:: html+jinja

    {#
     # This statement will only grab *visible* children node-sources and
     # will order them ascendently according to their *title*.
     #}
    {% set childrenBlocks = nodeSource.handler.children(
        {'node.visible': true},
        {'title': 'ASC'},
        securityContext
    ) %}


.. note::
    Calling ``getChildren`` from a node-source *handler* will always return ``NodesSources`` objects from
    the same translation as their parent.


Add previous and next links
---------------------------

In this example, we want to create links to jump to *next* and *previous* pages. We will use node-source handler methods
``getPrevious()`` and ``getNext()`` which work the same as ``getChildren`` method.

.. code-block:: html+jinja

    {% set prev = nodeSource.handler.previous(null,null,securityContext) %}
    {% set next = nodeSource.handler.next(null,null,securityContext) %}

    {% if (prev or next) %}
    <nav class="contextual-menu">
        {% if prev %}
        <a class="previous" href="{{ prev.handler.url }}"><i class="uk-icon-arrow-left"></i> {{ prev.title }}</a>
        {% endif %}
        {% if next %}
        <a class="next" href="{{ next.handler.url }}">{{ next.title }} <i class="uk-icon-arrow-right"></i></a>
        {% endif %}
    </nav>
    {% endif %}

.. note::
    Calling ``getPrevious`` and ``getNext`` from a node-source *handler* will always return ``NodesSources`` objects from
    the same translation as their sibling.

Displaying documents
--------------------

Did you noticed that *images* relation is available directly in nodeSource object? That’s a little shortcut to
``nodeSource.handler.documentFromFieldName('images')``. Cool, isn’t it? When you create your *documents* field in your
node-type, Roadiz generate a shortcut method for each document relation in your ``GeneratedNodesSources/NSxxxx`` class.

Now, you can use ``DocumentViewer`` to generate HTML view for your documents no matter they are *images*, *videos* or *embed*.

.. code-block:: html+jinja

    {# Grab only first document from “images” field #}
    {% set image = nodeSource.images[0] %}

    {# Always test if document exists #}
    {% if image %}
    {{ image.viewer.documentByArray({
        'width':200,
        'height':200,
        'crop':"1:1",
        'quality':75,
        'embed':true
    })|raw }}
    {% endif %}

HTML output options
^^^^^^^^^^^^^^^^^^^

* embed (true|false), display an embed as iframe instead of its thumbnail
* identifier
* class
* alt: If not filled, it will get the document name, then the document filename

Images resampling options
^^^^^^^^^^^^^^^^^^^^^^^^^

* width
* height
* crop ({w}x{h}, for example : 100x200)
* grayscale / greyscale (boolean)
* quality (1-100)
* background (hexadecimal color without #)
* progressive (boolean)
* noProcess (boolean) : Disable SLIR resample

Audio / Video options
^^^^^^^^^^^^^^^^^^^^^

* autoplay
* controls

You can find more details in `our API documentation <http://api.roadiz.io/RZ/Roadiz/Core/Viewers/DocumentViewer.html#method_getDocumentByArray>`_.

* If document is an **image**: ``getDocumentByArray`` method will generate an ``<img />`` tag with a ``src`` and ``alt`` attributes.
* If it’s a **video**, it will generate a ``<video />`` tag with as many sources as available in your document database. Roadiz will look for same filename with each HTML5 video extensions (filename.mp4, filename.ogv, filename.webm).
* Then if document is an **embed media**, it will generate an iframe according to its platform implementation (*Youtube*, *Vimeo*, *Soundcloud*).


Additional filters
------------------

Roadiz’s Twig environment implements some useful filters, such as:

* ``markdown``: Convert a markdown text to HTML
* ``inlineMarkdown``: Convert a markdown text to HTML without parsing *block* elements (useful for just italics and bolds)
* ``centralTruncate(length, offset, ellipsis)``: Generate an ellipsis at the middle of your text (useful for filenames). You can decenter the ellipsis position using ``offset`` parameter, and even change your ellipsis character with ``ellipsis`` parameter.

Standard filters and extensions are also available:

* ``{{ path('myRoute') }}``: for generating static routes Url.
* ``truncate`` and ``wordwrap`` which are parts of the `Text Extension <http://twig.sensiolabs.org/doc/extensions/text.html>`_ .

Create your own Twig filters
----------------------------

Imagine now that your are rendering some dynamic CSS stylesheets with Twig.
Your are listing your website projects which all have a distinct color. So you’ve created a
CSS route and a ``dynamic-colors.css.twig``.

.. code-block:: html+jinja

    {% for project in projects %}
    .{{ project.node.nodeName }} h1 {
        color: {{ project.color }};
    }
    {% endfor %}

This code should output a CSS like that:

.. code-block:: css

    .my-super-project h1 {
        color: #FF0000;
    }
    .my-second-project h1 {
        color: #00FF00;
    }

Then you should see your “super project” title in red on your website. OK, that’s great.
But what should I do if I need to use a RGBA color to control the Alpha channel value?
For example, I want to set project color to a ``<div class="date">`` background like this:

.. code-block:: css

    .my-super-project .date {
        background-color: rgba(255, 0, 0, 0.5);
    }
    .my-second-project .date {
        background-color: rgba(0, 255, 0, 0.5);
    }

*Great… I already see coming guys complaining that “rgba” is only supported since IE9… We don’t give a shit!…*

Hum, hum. So you need a super filter to extract decimal values from our backoffice stored hexadecimal color.
Roadiz enables us to extend Twig environment filters thanks to *dependency injection!*

You just have to extend ``setupDependencyInjection`` static method in your main
theme class. Create it if it does not exist yet.

.. code-block:: php

    // In your SuperThemeApp.php
    public static function setupDependencyInjection(\Pimple\Container $container)
    {
        parent::setupDependencyInjection($container);

        // We extend twig setup
        $container->extend('twig.environment', function ($twig, $c) {

            // The first filter will extract red value
            $red = new \Twig_SimpleFilter('red', function ($hex) {
                if ($hex[0] == '#' && strlen($hex) == 7) {
                    return hexdec(substr($hex, 1, 2));
                } else {
                    return 0;
                }
            });
            $twig->addFilter($red);

            // The second filter will extract green value
            $green = new \Twig_SimpleFilter('green', function ($hex) {
                if ($hex[0] == '#' && strlen($hex) == 7) {
                    return hexdec(substr($hex, 3, 2));
                } else {
                    return 0;
                }
            });
            $twig->addFilter($green);

            // The third filter will extract blue value
            $blue = new \Twig_SimpleFilter('blue', function ($hex) {
                if ($hex[0] == '#' && strlen($hex) == 7) {
                    return hexdec(substr($hex, 5, 2));
                } else {
                    return 0;
                }
            });
            $twig->addFilter($blue);

            // Then we return our extended twig environment
            return $twig;
        });
    }

And… Voilà! You can use ``red``, ``green`` and ``blue`` filters in your Twig template.

.. code-block:: html+jinja

    {% for project in projects %}
    .{{ project.node.nodeName }} .date {
        background-color: rgba({{ project.color|red }}, {{ project.color|green }}, {{ project.color|blue }}, 0.5);
    }
    {% endfor %}
