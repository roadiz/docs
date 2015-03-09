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

            return $this->render('types/page.html.twig', $this->assignation);
        }
    }

You will be able to render your page using ``themes/MyTheme/Resources/views/types/page.html.twig``
template file:

.. code-block:: html+jinja

    {% extends 'base.html.twig' %}

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
                $this->getService('securityContext')
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

        {% include 'blocks/' ~ pageBlock.node.nodeType.name|lower ~ '.html.twig' with {
            'loop': loop,
            'nodeSource': pageBlock,
            'themeServices': themeServices,
            'securityContext': securityContext
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
