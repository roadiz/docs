.. _using-twig:

==========
Using Twig
==========

.. Note::

    Twig is the default rendering engine for *Roadiz* CMS. You’ll find its documentation at http://twig.sensiolabs.org/doc/templates.html

When you use :ref:`Dynamic routing <dynamic-routing>` within your theme, Roadiz will automatically assign some variables for you::

    * **request** — [object] Symfony request object which contains useful data such as current URI or GET parameters
    * **head**
        * **ajax** — [boolean] Tells if current request is an Ajax one
        * **cmsVersion** — [string]
        * **cmsBuild** — [string]
        * **devMode** — [boolean]
        * **baseUrl** — [string] Server base Url. Basically your domain name, port and folder if you didn’t setup Roadiz at you server root
        * **filesUrl** — [string]
        * **resourcesUrl** — [string] Your theme ``Resources`` url. Useful to reach your assets.
        * **ajaxToken** — [string]
        * **fontToken** — [string]
    * **session**
        * **messages** — [array]
        * **id** — [string]
        * **user** — [object]
    * **securityContext** — [object]

There are some more content only available from *FrontendControllers*::

    * **_default_locale** — [string]
    * **meta**
        * **siteName** — [string]
        * **siteCopyright** — [string]
        * **siteDescription** — [string]

Then, in each dynamic routing *actions* you will need this line ``$this->storeNodeAndTranslation($node, $translation);``
in order to make page content available from your Twig template::

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
        <h1><a href="{{ nodeSource.handler.getUrl }}">{{ nodeSource.title }}</a></h1>
        <div>{{ nodeSource.content|markdown }}</div>

        {# Use complex syntax to grab documents #}
        {% set images = nodeSource.handler.documentsFromFieldName('images') %}
        {# or Shortcut syntax #}
        {% set images = nodeSource.images %}

        {% for image in images %}

            {% set imageMetas = image.documentTranslations.first %}
            <figure>
                {{ image.viewer.getDocumentByArray({ width:200 })|raw }}
                <figcaption>{{ imageMetas.name }} — {{ imageMetas.copyright }}</figcaption>
            </figure>
        {% endfor %}
    </article>

Handling Nodes and NodesSources with Twig
-----------------------------------------

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
            {{ image.viewer.documentByArray({ width:200 })|raw }}
            <figcaption>{{ imageMetas.name }} — {{ imageMetas.copyright }}</figcaption>
        </figure>
    {% endfor %}

Did you noticed that *images* relation is available directly in nodeSource object? That’s a little shortcut to
``nodeSource.handler.documentFromFieldName('images')``. Cool, isn’t it? When you create your *documents* field in your
node-type, Roadiz generate a shortcut method for each document relation in your ``GeneratedNodesSources/NSxxxx`` class.


Additional filters
------------------

Roadiz’s Twig environment implements some useful filters, such as:

* ``markdown``: Convert a markdown text to HTML
* ``inlineMarkdown``: Convert a markdown text to HTML without parsing *block* elements (useful for just italics and bolds)
* ``centralTruncate(length, offset, ellipsis)``: Generate an ellipsis at the middle of your text (useful for filenames). You can decenter the ellipsis position using ``offset`` parameter, and even change your ellipsis character with ``ellipsis`` parameter.

Standard filters and extensions are also available:

* ``{{ path('myRoute') }}``: for generating static routes Url.
* ``truncate`` and ``wordwrap`` which are parts of the `Text Extension <http://twig.sensiolabs.org/doc/extensions/text.html>`_ .
