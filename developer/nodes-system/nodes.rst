.. _nodes:

==================================
Handling nodes and their hierarchy
==================================

By default, if you use Entities API methods or trasversing Twig filters,
Roadiz will automatically handle security parameters such as ``node.status`` and
``preview`` mode.

.. code-block:: php

    // Secure method to get node-sources
    // Implicitly check node.status
    $this->get('nodeSourceApi')->getBy([
        'node.nodeType' => $blogPostType,
        'translation' => $translation,
    ], [
        'publishedAt' => 'DESC'
    ]);

This first code snippet is using *Node-source API*. This will automatically check if
current user is logged-in and if preview mode is *ON* to display or not *unpublished nodes*.

.. code-block:: php

    // Insecure method to get node-sources
    // Doctrine raw method will get all node-sources
    $this->get('em')->getRepository('GeneratedNodeSources\NSBlogPost')->findBy([], [
        'publishedAt' => 'DESC',
        'translation' => $translation,
    ]);

This second code snippet uses standard Doctrine *Entity Manager* to directly grab
node-sources by their entity class. This method does not check any security and will
return every node-sources, **even unpublished, archived and deleted ones**.

Hierarchy
^^^^^^^^^

To trasverse node-sources hierarchy, the easier method is to use *Twig* filters
on your ``nodeSource`` entity. Filters will implicitly set ``translation`` from
origin node-source.

.. code-block:: html+jinja

    {% set children = nodeSource|children %}
    {% set nextSource = nodeSource|next %}
    {% set prevSource = nodeSource|previous %}
    {% set parent = nodeSource|parent %}

    {% set children = nodeSource|children({
        'node.visible': true
    }) %}

.. warning::

    All these filters will take care of publication status and translation, **but not publication date-time neither visibility**.

.. code-block:: html+jinja

    {% set children = nodeSource|children({
        'node.visible': true,
        'publishedAt': ['>=', date()],
    }, {
        'publishedAt': 'DESC'
    }) %}

    {% set nextVisible = nodeSource|next({
        'node.visible': true
    }) %}

If you need to trasverse node-source hierarchy from your controllers you can use
the ``NodesSourcesHandler`` class from the handler factory service.

.. code-block:: php

    use RZ\Roadiz\Core\Handlers\NodesSourcesHandler;
    // …
    $nodeSourceHandler = $this->get('factory.handler')->getHandler($nodeSource);

    $children = $nodeSourceHandler->getChildren([
        'node.visible' => true,
        'publishedAt' => ['>=', new \DateTime()],
        'translation' => $nodeSource->getTranslation(),
    ],[
        'publishedAt' => 'DESC'
    ]);

Or directly use *Entity API*.

.. code-block:: php

    $children = $this->get('nodeSourceApi')->getBy([
        'node.parent' => $nodeSource,
        'node.visible' => true,
        'publishedAt' => ['>=', new \DateTime()],
        'translation' => $nodeSource->getTranslation(),
    ],[
        'publishedAt' => 'DESC'
    ]);

Visibility
^^^^^^^^^^

There are two parametres that you must take care of in your themes and your
controllers, because they are not mandatory in all website cases:

- Visibility
- Publication date and time

For example, *publication date and time* won’t be necessary in plain text pages and
not timestampable contents. But we decided to add it directly in ``NodesSources``
entity to be able to filter and order with this field in Roadiz back-office.
This was not possible if you manually create your own ``publishedAt`` as a node-type
field.

.. warning::
    Pay attention that *publication date and time* (``publishedAt``) and visibility
    (``node.visible``) **does not prevent** your node-source from being viewed
    if you did not explicitly forbid access to its controller. This field is not
    deeply set into Roadiz security mechanics.

    If you need so, make sure that your node-type controller checks these two
    fields and throws a ``ResourceNotFoundException`` if they’re not satisfied.

.. code-block:: php

    class BlogPostController extends MyAwesomeTheme
    {
        public function indexAction(
            Request $request,
            Node $node = null,
            Translation $translation = null
        ) {
            $this->prepareThemeAssignation($node, $translation);

            $now = new DateTime("now");
            if (!$nodeSource->getNode()->isVisible() ||
                $nodeSource->getPublishedAt() < $now) {
                throw new ResourceNotFoundException();
            }

            return $this->render(
                'types/blogpost.html.twig',
                $this->assignation
            );
        }
    }


