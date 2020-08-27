.. _display-documents:

====================
Displaying documents
====================

Did you noticed that *images* relation is available directly in nodeSource object? That’s a little shortcut to
``(nodeSource|handler).documentFromFieldName('images')``. Cool, isn’t it? When you create your *documents* field in your
node-type, Roadiz generate a shortcut method for each document relation in your ``GeneratedNodesSources/NSxxxx`` class.

Now, you can use the ``DocumentViewer`` service to generate HTML view for your documents no matter they are *images*, *videos* or *embed*. Two *Twig* filters are available with ``Documents``:

- ``|display`` generates an HTML tag to display your document.
- ``|url`` generates a public URL to reach your document.
- ``|embedFinder`` gets the EmbedFinder for current document according to the embed-platform type (Youtube, Vimeo, Soundcloud…).

.. code-block:: html+jinja

    {# Grab only first document from “images” field #}
    {% set image = nodeSource.images[0] %}

    {# Always test if document exists #}
    {% if image %}
    {{ image|display({
        'width':200,
        'height':200,
        'crop':"1:1",
        'quality':75,
        'embed':true
    }) }}
    {% endif %}

HTML output options
-------------------

* **absolute** (true|false, default: ``false``), generates an *absolute* URL with protocol, domain-name and base-url. This must be used for social network images.
* **embed** (true|false, default: ``false``), display an embed as iframe instead of its thumbnail
* **identifier**
* **class**
* **alt**: If not filled, it will get the document name, then the document filename
* **lazyload** (true|false, default: ``false``), fill image src in a ``data-src`` attribute instead of ``src`` to prevent it from loading. It will add automatically ``lazyload_class`` class to your HTML image.
* **lazyload_class** (default: ``lazyload``) Class name to be added when enabling lazyloading.
* **fallback** (URL|data-uri) Defines a custom fallback image URL or *data-uri* when using ``lazyload`` option in order to fill ``src`` attribute and validate against W3C
* **blurredFallback** (false|true, default: ``false``) Generated a very low quality image version for lazyload fallback to better control image size and better experience.
* **picture** (false|true, default: ``false``), use ``<picture>`` element instead of image and allow serving WebP image to compatibles browsers. **Only use if your server support WebP**.
* **inline** (true|false, default: ``true``), **for SVG**, display SVG inline code in html instead of using an ``<object>`` tag. Default ``true``.
* **loading** (auto|lazy|eager|null, default: ``null``), for next-gen browser only that will support native lazy-loading. This will be applied only on `img`, `picture` and `iframe` elements. *This can fail W3C validation*.

Images resampling options
^^^^^^^^^^^^^^^^^^^^^^^^^

* **width**
* **height**
* **crop** (ratio: ``{w}:{h}``, for example : ``16:9``)
* **fit** (fixed dimensions: ``{w}x{h}``, for example : ``100x200``), if you are using *fit* option, Roadiz will be able to add ``width`` and ``height`` attributes to your ``<img>`` tag.
* **align**, to use along with ``fit`` parameter to choose which part of the picture to fit. Allowed options:
    * top-left
    * top
    * top-right
    * left
    * center
    * right
    * bottom-left
    * bottom
    * bottom-right
* **grayscale** (boolean, default: ``false``)
* **quality** (1-100, default: ``90``)
* **flip** (``h`` or ``v``), mirror your image vertical or horizontal
* **blur** (1-100, default: ``0``) *(can be really slow to process)*
* **sharpen** (1-100, default: ``0``)
* **contrast** (1-100, default: ``0``)
* **background** (hexadecimal color without #)
* **progressive** (boolean, default: ``false``), it will interlace the image if it’s a *PNG* file.
* **noProcess** (boolean, default: ``false``): Disable image processing, useful if you want to keep animated GIF

Audio / Video options
^^^^^^^^^^^^^^^^^^^^^

* **autoplay** (boolean, default: ``false``)
* **controls** (boolean, default: ``true``)
* **loop** (boolean, default: ``false``)
* **muted** (boolean, default: ``false``)
* **custom_poster** (string): URL to a image to be used as video poster

For *Soundcloud* embeds

* **hide_related** (boolean, default: ``false``)
* **show_comments** (boolean, default: ``false``)
* **show_user** (boolean, default: ``false``)
* **show_reposts** (boolean, default: ``false``)
* **visual** (boolean, default: ``false``)

For *Mixcloud* embeds

* **mini** (boolean, default: ``false``)
* **light** (boolean, default: ``true``)
* **hide_cover** (boolean, default: ``true``)
* **hide_artwork** (boolean, default: ``false``)

For *Vimeo* embeds

* **displayTitle** (boolean, default: ``false``)
* **byline** (boolean, default: ``false``)
* **portrait** (boolean, default: ``false``)
* **color** (boolean)
* **api** (boolean, default: ``true``)
* **automute** (boolean, default: ``false``)
* **autopause** (boolean, default: ``false``)

For *Youtube* `embeds <https://developers.google.com/youtube/player_parameters>`_

* **modestbranding** (boolean, default: ``true``)
* **rel** (boolean, default: ``false``)
* **showinfo** (boolean, default: ``false``)
* **start** (integer, default: ``false``)
* **end** (integer, default: ``false``)
* **enablejsapi** (boolean, default: ``true``)
* **playlist** (boolean, default: ``false``)
* **playsinline** (boolean, default: ``false``): Allow iframe to play inline on iOS

You can use **multiple source files** for one video document or audio document.
Just upload a file using tge same filename name but with a different extension. Use this method to
add a poster image to your video too.
For example: for ``my-video.mp4`` file, upload ``my-video.webm``, ``my-video.ogg``
and ``my-video.jpeg`` documents. *Roadiz* will automatically generate a ``<video>`` tag using all these files as *source* and
*poster* attribute.

Using src-set attribute for responsive images
---------------------------------------------

Roadiz can generate a ``srcset`` attribute to create a responsive image
tag like the one you can find `on these examples <https://responsiveimages.org/>`_.

* **srcset** (Array) Define for each rule an Array of format. `Specifications <https://www.w3.org/html/wg/drafts/html/master/semantics.html#attr-img-srcset>`_
* **media** (Array) Define one ``srcset`` for each media-query. You cannot use ``media`` without ``picture`` option.

.. code-block:: html+jinja

    {% set image = nodeSource.images[0] %}
    {% if image %}
    {{ image|display({
        'fit':'600x600',
        'quality':75,
        'srcset': [
            {
                'format': {
                    'fit':'200x200',
                    'quality':90
                },
                'rule': '780w',
            },
            {
                'format': {
                    'fit':'600x600',
                    'quality':75
                },
                'rule': '1200w',
            }
        ],
        'sizes': [
            '(max-width: 780px) 200px',
            '(max-width: 1200px) 600px',
        ],
    }) }}
    {% endif %}

This will output an ``img`` tag like the following one:

.. code-block:: html

    <img src="/assets/f600x600-q75/image.jpg"
         srcset="/assets/f600x600-q75/image.jpg 1200w, /assets/f200x200-q90/image.jpg 780w"
         sizes="(max-width: 780px) 200px, (max-width: 1200px) 600px"
         alt="A responsive image">

Generate <picture> elements
---------------------------

If you want to combine ``srcset`` for media queries **and** device ratio, use ``picture`` element with ``media`` option:

.. code-block:: html+jinja

    {% set image = nodeSource.images[0] %}
    {% if image %}
    {{ image|display({
        'fit':'640x400',
        'quality':75,
        'picture': true,
        'media': [
            {
                'srcset': [
                    {
                        'format': {
                            'fit':'320x200',
                            'quality':90
                        },
                        'rule': '1x',
                    },
                    {
                        'format': {
                            'fit':'640x400',
                            'quality':75
                        },
                        'rule': '2x',
                    }
                ],
                'rule': '(max-width: 767px)'
            },
            {
                'srcset': [
                    {
                        'format': {
                            'fit':'800x600',
                            'quality':80
                        },
                        'rule': '1x',
                    },
                    {
                        'format': {
                            'fit':'1600x1200',
                            'quality':70
                        },
                        'rule': '2x',
                    }
                ],
                'rule': '(min-width: 768px)'
            }
        ]
    }) }}
    {% endif %}

This will output a ``picture`` element supporting :

- *WebP* image format (*Roadiz* will automatically generate a ``.webp`` image if your PHP is compiled with *webp* support)
- *Media query* attributes
- *Device ratio* src-set rules
- A fallback ``img`` element for older browsers

.. code-block:: html

    <picture>
        <source media="(max-width: 767px)"
                srcset="/assets/f320x200-q90/folder/file.jpg.webp 1x, /assets/f640x400-q75/folder/file.jpg.webp 2x"
                type="image/webp">
        <source media="(max-width: 767px)"
                srcset="/assets/f320x200-q90/folder/file.jpg 1x, /assets/f640x400-q75/folder/file.jpg 2x"
                type="image/jpeg">

        <source media="(min-width: 768px)"
                srcset="/assets/f800x600-q80/folder/file.jpg.webp 1x, /assets/f1600x1200-q70/folder/file.jpg.webp 2x"
                type="image/webp">
        <source media="(min-width: 768px)"
                srcset="/assets/f800x600-q80/folder/file.jpg 1x, /assets/f1600x1200-q70/folder/file.jpg 2x"
                type="image/jpeg">

        <img alt="file.jpg"
             src="/assets/f640x400-q75/folder/file.jpg"
             width="640" height="400" />
    </picture>

More document details
---------------------

You can find more details in `our API documentation <http://api.roadiz.io/RZ/Roadiz/Core/Viewers/DocumentViewer.html#method_getDocumentByArray>`_.

* If document is an **image**: ``getDocumentByArray`` method will generate an ``<img />`` tag with a ``src`` and ``alt`` attributes.
* If it’s a **video**, it will generate a ``<video />`` tag with as many sources as available in your document database. Roadiz will look for same filename with each HTML5 video extensions (filename.mp4, filename.ogv, filename.webm).
* Then if document is an external media **and** if you set the ``embed`` flag to ``true``, it will generate an iframe according to its platform implementation (*Youtube*, *Vimeo*, *Soundcloud*).
* Get the external document URI (the one used for creating iframe for example) with ``(document|embedFinder).source(options…)`` twig command.

Displaying document metas
-------------------------

Documents can have *name*, *description* and *copyright* (which can be translated),
just access them using ``documentTranslations`` multiple relation
(``documentTranslations.first`` should always contain current context’ translation):

.. code-block:: html+jinja

    {% for document in nodeSource.documents %}
        <div class="document-item">
            {{ document|display }}

            {% set metas = document.documentTranslations.first %}
            <h3 class="document-item-name">{{ metas.name }}</h3>
            <div class="document-item-description">{{ metas.description|markdown }}</div>
            <em class="document-item-copyright">{{ metas.copyright }}</em>
        </div>
    {% endfor %}

Displaying document thumbnails
------------------------------

Embed and non-HTML documents will not display automatically their thumbnails, even if they got one.
Native videos and audios will always try to display ``<video>`` or ``<audio>`` elements, so if you need to force
display their thumbnail image you’ll need to write it manually:

.. code-block:: html+jinja

    {% for document in nodeSource.documents %}
        <div class="document-item">
            {% if document.hasThumbnails %}
                {{ document.thumbnails[0]|display }}
            {% else %}
                {{ document|display({
                    'controls': true,
                    'autoplay': false
                }) }}
            {% endif %}
        </div>
    {% endfor %}

Non-viewable document types, such as *PDF*, *Word*, *Excel*, *Archives*…, will always use their thumbnail image,
if there is one, when you call ``{{ document|display }}``.

Manage global documents
-----------------------

You can store documents inside *settings* for global images such as header images or website logo.
Simply create a new *setting* in Roadiz back-office choosing *Document* type, then a file selector will appear in settings list to upload your picture.

To use this document setting in your theme, you can assign it globally in your ``MyThemeApp::extendAssignation`` method.
Use ``getDocument`` method instead of ``get`` to fetch a ``Document`` object  that you’ll be able to display in
your Twig templates:

.. code-block:: php

    $document = $this->get('settingsBag')->getDocument('site_logo');

Or in a Twig template:

.. code-block:: html+jinja

    <figure id="site-logo">{{ bags.settings.getDocument('site_logo')|display }}</figure>

This way is the easiest to fetch a global document, but it needs you to upload it once in *Settings* section.
If this does not suit you, you can always fetch a *Document* manually using its *Doctrine* repository and a hard-coded ``filename``.

.. code-block:: php

    $this->assignation['head']['site_logo'] = $this->get('em')->getRepository(Document::class)->findOneByFilename('logo.svg');
