.. _custom-assignations:

===============================
Extending your Twig assignation
===============================

For a simple website theme, base assignation will work for almost every cases.
Using ``node`` or ``nodeSource`` data from your Twig template, you will be able to
render all your page fields.

Now imagine you need to load data from another node than the one being
requested. Or imagine that you want to create a complex homepage which displays a summary
of your latest news. You will need to extend existing assignated variables.

For example, create a simple node-type called *Page*. Add several basic fields inside it
such as *content* and *images*. If you well-understood :ref:`how to create a theme <create-theme>` section you will
create a *PageController.php* which look like this:

.. code-block:: php

    <?php
    namespace Themes\MyTheme\Controllers;

    use Themes\MyTheme\MyThemeApp;
    use RZ\Roadiz\Core\Entities\Node;
    use RZ\Roadiz\Core\Entities\Translation;
    use Symfony\Component\HttpFoundation\Request;

    /**
     * Frontend controller to handle Page node-type request.
     */
    class PageController extends MyThemeApp
    {
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

            return $this->render('types/page.html.twig', $this->assignation, null, static::getThemeDir());
        }
    }

You will be able to render your page using ``themes/MyTheme/Resources/views/types/page.html.twig``
template file:

.. code-block:: html+jinja

    {% extends '@MyTheme/base.html.twig' %}

    {% block content %}

    <h1>{{ nodeSource.title }}</h1>
    <div class="content">{{ nodeSource.content|markdown }}</div>
    <div class="images">
        {% for image in nodeSource.images %}
            <figure>
                {{ image|display }}
            </figure>
        {% endfor %}
    </div>
    {% endblock %}

Use theme-wide assignation
--------------------------

Custom assignations are great but what can I do if I have to use the same
variables in several controllers? We added a special ``extendAssignation`` method
which is called at the end of your theme preparation process
(``prepareThemeAssignation`` and ``prepareNodeSourceAssignation``). Just override it
in your ``MyThemeApp`` main class, then every theme controllers and templates
will be able to use these variables.

For example, you can use this method to make ``<head>`` variables available
for each of your website pages.

.. code-block:: php

    /**
     * {@inheritdoc}
     */
    protected function extendAssignation()
    {
        parent::extendAssignation();

        $this->assignation['head']['facebookUrl'] = SettingsBag::get('facebook_url');
        $this->assignation['head']['facebookClientId'] = SettingsBag::get('facebook_client_id');
        $this->assignation['head']['instagramUrl'] = SettingsBag::get('instagram_url');
        $this->assignation['head']['twitterUrl'] = SettingsBag::get('twitter_url');
        $this->assignation['head']['googleplusUrl'] = SettingsBag::get('googleplus_url');
        $this->assignation['head']['googleClientId'] = SettingsBag::get('google_client_id');
        $this->assignation['head']['maps_style'] = SettingsBag::get('maps_style');
        $this->assignation['head']['themeName'] = static::$themeName;
        $this->assignation['head']['themeVersion'] = static::VERSION;
    }

Use *Page / Block* data pattern
-------------------------------

At REZO ZERO, we often use complex page design which need removable and movable
parts. At first we used to create long node-types with a lot of fields, and when
editors needed to move content to an other position, they had to cut and paste text
to another field. It was long and not very sexy.

So we thought about a modulable way to build pages. We decided to use one master node-type and
several slave node-types instead of a single big type. Here is what we call **Page/Block pattern**.

This pattern takes advantage of Roadiz node hierarchy. We create a very light *Page* node-type, with
an *excerpt* and a *thumbnail* fields, then we create an other node-type that we will call *BasicBlock*.
This block node-type will have a *content* and *image* fields.

The magic comes when we add a last field into *Page* master node-type called *children_nodes*. This special
field will display a node-tree inside your edit page. In this field parameter, we add *BasicBlock* name as a default
value to tell Roadiz that each *Page* nodes will be able to contain *BasicBlock* nodes.

So you understood that all your page data will be allocated in several *BasicBlock* nodes. Then your
editor will just have to change block order to re-arrange your page content. That’s not all! With this
pattern you can join images to each block so that each paragraph can be pictured with a *Document* field.
No need to insert image tags right into your Markdown text as you would do in a Wordpress article.

How to template *Page / Block* pattern
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now that you’ve structured your data with a *Page* node-type and a *BasicBlock*, how do render your data
in only one page and only one URL request? We will use custom assignations!

Open your ``PageController.php`` file:

.. code-block:: php

    …
    $this->prepareThemeAssignation($node, $translation);
    // Add your additional assignations after this method.

    // Get BasicBlock node-type entity to filter
    // over current node children
    $basicBlockType = $this->getService('nodeTypeApi')
                           ->getOneBy(['name' => 'BasicBlock']);

    // Assign blocks using current nodeSource children
    // filtering them by node-type (only BasicBlock nodes
    // will be queried)
    //
    // http://api.roadiz.io/RZ/Roadiz/Core/Handlers/NodesSourcesHandler.html#method_getChildren
    $this->assignation['blocks'] =
        $this->assignation['nodeSource']
             ->getHandler()
             ->getChildren(
                [
                    'node.nodeType' => $basicBlockType
                ],
                [
                    'node.position' => 'ASC'
                ],
                $this->getService('securityAuthorizationChecker')
             );


.. note::
    You can use different *block* types in the same *page*. Just create as many
    node-types as you need and add their name to your *Page* ``children_node`` default values.
    Then add each node-type into ``getChildren`` criteria using an array instead of
    a single value: ``'node.nodeType' => array($basicBlockType, $anotherBlockType)``. That way, you
    will be able to create awesome pages with different looks but with the same template
    (basic blocks, gallery blocks, etc).

Now we can update your ``types/page.html.twig`` template to use your assignated blocks.

.. code-block:: html+jinja

    …
    {% if blocks %}
    <section class="page-blocks">
    {% for pageBlock in blocks %}

        {% include '@MyTheme/blocks/' ~ pageBlock.node.nodeType.name|lower ~ '.html.twig' with {
            'loop': loop,
            'nodeSource': pageBlock,
            'themeServices': themeServices
        } only %}

    {% endfor %}
    </section>
    {% endif %}

*Whaaat? What is that include?* This trick will save you a lot of time! We ask Twig to
include a sub-template according to each block type name. Eg. for a *BasicBlock* node,
Twig will include a ``blocks/basicblock.html.twig`` file. It’s even more powerful when
you are using multiple block types because Twig will automatically choose the right
template to render each part of your page.

Then create each of your blocks templates files in ``blocks`` folder:

.. code-block:: html+jinja

    {# This is file: blocks/basicblock.html.twig #}

    <div class="basicblock {% if loop.index0 is even %}even{% else %}odd{% endif %}">
        {#
         # Did you notice that 'pageBlock' became 'nodeSource' as
         # we passed it during include for a better compatibility
         #}
        <h3>{{ nodeSource.title }}</h3>
        <div class="content">{{ nodeSource.content|markdown }}</div>

        <div class="images">
        {% for image in nodeSource.images %}
            <figure>
                {{ image|display({'width':200}) }}
            </figure>
        {% endfor %}
        </div>
    </div>

*Voilà!*
This is the simplest example to demonstrate you the power of *Page / Block*
pattern. If you managed to reproduce this example you can now try it using
multiple *block* node-types, combining multiple sub-templates.

Use block rendering
-------------------

A few times, using *Page / Block* pattern won’t be enough to display your
page blocks. For example, you will occasionally need to create a form inside
a block, or you will need to process some data before using them in your Twig
template.

For this we added a ``render`` filter which basically create a sub-request to render
your block. This new request make possible to create a dedicated ``Controller`` for
your block.

Let’s take the previous example about a page with several *basic blocks* inside.
Imagine you have a new *contact block* to insert in your page, then how would you
create your form? The following code shows how to “embed” a sub-request inside
your block template.

.. code-block:: html+jinja

    {#
     # This is file: blocks/contactblock.html.twig
     #}
    <div class="contactblock {% if loop.index0 is even %}even{% else %}odd{% endif %}">

        <h3>{{ nodeSource.title }}</h3>
        <div class="content">{{ nodeSource.content|markdown }}</div>

        {#
         # We created a display_form node-type field to enable/disable form
         # but this is optional
         #}
        {% if nodeSource.displayForm %}
            {#
             # “render” twig filter initiate a new Roadiz request
             # using *nodeSource* as primary content. It takes one
             # argument to locate your block controller
             #}
            {{ nodeSource|render('MyTheme') }}
        {% endif %}
    </div>

Then Roadiz will look for a ``Themes\MyTheme\Controllers\Blocks\ContactBlockController.php`` file
and a ``blockAction`` method inside.

.. code-block:: php

    namespace Themes\MyTheme\Controllers\Blocks;

    use RZ\Roadiz\Core\Entities\NodesSources;
    use RZ\Roadiz\Core\Exceptions\ForceResponseException;
    use Symfony\Component\HttpFoundation\Request;
    use Themes\MyTheme\MyThemeApp;

    class ContactBlockController extends MyThemeApp
    {
        function blockAction(Request $request, NodesSources $source, $assignation)
        {
            $this->prepareNodeSourceAssignation($source, $source->getTranslation());

            $this->assignation = array_merge($this->assignation, $assignation);

            // If you assignate session messages here, do not assignate it in your
            // MyThemeApp::extendAssignation() method before.
            $this->assignation['session']['messages'] = $this->getService('session')->getFlashBag()->all();

            /*
             * Add your form code here, for example
             */
            $form = $this->createFormBuilder()->add('name', 'text')
                                              ->add('send_name', 'submit')
                                              ->getForm();
            $form->handleRequest($request);
            if ($form->isValid()) {
                // some stuff
                throw new ForceResponseException($this->redirect($request->getUri()));
            }

            $this->assignation['contactForm'] = $form->createView();

            return $this->render('form-blocks/contactblock.html.twig', $this->assignation);
        }
    }

Then create your template ``form-blocks/contactblock.html.twig``:

.. code-block:: html+jinja

    <div class="contact-form">
        {% for messages in session.messages %}
            {% for message in messages %}
                <p class="alert alert-success">{{ message }}</p>
            {% endfor %}
        {% endfor %}

        {{ form(contactForm) }}
    </div>

Paginate entities using EntityListManager
-----------------------------------------

Roadiz implements a powerful tool to display lists and paginate them.
Each ``Controller`` class allows developer to use ``createEntityListManager``
method.

In ``FrontendController`` inheriting classes, such as your theme ones, this method
is overriden to automatically use the current ``authorizationChecker`` to filter entities
by status when entities are *nodes*.

``createEntityListManager`` method takes 3 arguments:

- **Entity classname**, i.e. ``RZ\Roadiz\Core\Entities\Nodes`` or ``GeneratedNodeSources\NSArticle``. The great thing is that you can use it on a precise ``NodesSources`` class instead of using *Nodes* or *NodesSources* then filtering on *node-type*. Using a ``NS`` entity allows you to filter on your own custom fields too.
- **Criteria array**, (optional)
- **Ordering array**, (optional)

*EntityListManager* will automatically grab the current page looking for your Request parameters.
If ``?page=2`` is set or ``?search=foo``, it will use them to filter your list and choose the right page.

If you want to handle pagination manually, you always can set it with ``setPage(page)`` method, which must be called **after**
handling *EntityListManager*. It is useful to bind page parameter in your *routing* configuration.

.. code-block:: yaml

    projectPage:
        path:     /articles/{page}
        defaults: { _controller: Themes\MyAwesomeTheme\Controllers\ArticleController::listAction, page: 1 }
        requirements:
            page: "[0-9]+"

Then, build your ``listAction`` method.

.. code-block:: php

    public function listAction(
        Request $request,
        $page,
        $_locale = 'en'
    ) {
        $translation = $this->bindLocaleFromRoute($request, $_locale);
        $this->prepareThemeAssignation(null, $translation);

        $listManager = $this->createEntityListManager(
            'GeneratedNodeSources\\NSArticle',
            ['sticky' => false], //sticky is a custom field from Article node-type
            ['node.createdAt' => 'DESC']
        );
        /*
         * First, set item per page
         */
        $listManager->setItemPerPage(20);
        /*
         * Second, handle the manager
         */
        $listManager->handle();
        /*
         * Third, set current page manually
         * AFTER handling entityListManager
         */
        if ($page > 1) {
            $listManager->setPage($page);
        }

        $this->assignation['articles'] = $listManager->getEntities();
        $this->assignation['filters'] = $listManager->getAssignation();

        return $this->render('types/articles-feed.html.twig', $this->assignation);
    }

Then create your ``articles-feed.html.twig`` template to display each entity paginated.

.. code-block:: html+jinja

    {# Listing #}
    <ul class="article-list">
        {% for article in articles %}
            <li class="article-item">
                <a class="article-link" href="{{ article|url }}">
                    <h2>{{ article.title }}</h2>
                </a>
            </li>
        {% endfor %}
    </ul>

    {# Pagination #}
    {% if filters.pageCount > 1 %}
        <nav class="pagination">
            {% if filters.currentPage > 1 %}
                <a class="prev-link" href="{{ path('projectPage', {page: filters.currentPage - 1}) }}">
                    {% trans %}prev.page{% endtrans %}
                </a>
            {% endif %}
            {% if filters.currentPage < filters.pageCount %}
                <a class="next-link" href="{{ path('projectPage', {page: filters.currentPage + 1}) }}">
                    {% trans %}next.page{% endtrans %}
                </a>
            {% endif %}
        </nav>
    {% endif %}
