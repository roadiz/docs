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

If you need to trasverse node-source graph from your controllers you can use
the *Entity API*. Moreover, Nodes-sources API allows you to filter using custom criteria if you choose a specific ``NodeType``.

.. code-block:: php

    $children = $this->get('nodeSourceApi')->getBy([
        'node.parent' => $nodeSource,
        'node.visible' => true,
        'publishedAt' => ['>=', new \DateTime()],
        'translation' => $nodeSource->getTranslation(),
    ],[
        'publishedAt' => 'DESC'
    ]);

.. warning::

    Browsing your node graph (calling children or parents) could be very greedy and unoptimized if you have lots of node-types. Internally *Doctrine* will *inner-join* every nodes-sources tables to perform polymorphic hydratation. So, make sure you filter your queries by one ``NodeType`` as much as possible with ``nodeSourceApi`` and ``node.nodeType`` criteria.

    .. code-block:: php

        // Here Doctrine will only join NSPage table to NodesSources
        $children = $this->get('nodeSourceApi')->getBy([
            'node.nodeType' => $this->get('nodeTypesBag')->get('Page'),
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

Publication workflow
^^^^^^^^^^^^^^^^^^^^

Each Node state is handled by a *Workflow* to switch between the following 5 states:

.. rubric:: States

    - ``Node::DRAFT``
    - ``Node::PENDING``
    - ``Node::PUBLISHED``
    - ``Node::ARCHIVED``
    - ``Node::DELETED``

.. rubric:: Transitions

    - review
    - reject
    - publish
    - archive
    - unarchive
    - delete
    - undelete

You cannot changes a Node status directly using its *setter*, you must use Roadiz main *registry* to perform
transition. This can prevent unwanted behaviours and you can track changes with events and guards:

.. code-block:: php

    /** @var Registry $registry */
    $registry = $this->get('workflow.registry');
    if ($registry->get($node)->can($node, 'publish')) {
        $registry->get($node)->apply($node, 'publish');
    }


Generating paths and url
^^^^^^^^^^^^^^^^^^^^^^^^

You can use ``generateUrl()`` in your controllers to get a node-source’ path or url. In your Twig template, you can use ``path`` method as described in Twig section: :ref:`twig-generate-paths`.

.. code-block:: php

    class BlogPostController extends MyAwesomeTheme
    {
        public function indexAction(
            Request $request,
            Node $node = null,
            Translation $translation = null
        ) {
            $this->prepareThemeAssignation($node, $translation);

            // Generate a path for current node-source
            $path = $this->generateUrl($this-nodeSource);

            // Generate an absolute URL for current node-source
            $absoluteUrl =  $this->generateUrl(
                $this->nodeSource,
                [],
                UrlGeneratorInterface::ABSOLUTE_URL
            );
        }
    }

.. _override_default_path:

Overriding default node-source path generation
----------------------------------------------

You can override default node-source path generation in order to use ``{{ path() }}`` method
in your *Twig* templates but with a custom logic. For example, you have a ``Link`` node-type
which purpose only is to link to an other node in your website. When you call *path* or *URL*
generation on it, you should prefer getting its linked node path, so you can listen
to ``NodesSourcesEvents::NODE_SOURCE_PATH_GENERATING`` event and stop propagation to return
your linked node path instead of your *link* node path.

.. code-block:: php

    use GeneratedNodeSources\NSLink;
    use RZ\Roadiz\Core\Events\FilterNodeSourcePathEvent;
    use RZ\Roadiz\Core\Events\NodesSourcesEvents;
    use Symfony\Component\EventDispatcher\EventDispatcherInterface;
    use Symfony\Component\EventDispatcher\EventSubscriberInterface;

    class LinkPathGeneratingEventListener implements EventSubscriberInterface
    {
        public static function getSubscribedEvents()
        {
            return [
                NodesSourcesEvents::NODE_SOURCE_PATH_GENERATING => ['onLinkPathGeneration']
            ];
        }

        /**
         * @param FilterNodeSourcePathEvent $event
         * @param string                    $eventName
         * @param EventDispatcherInterface  $dispatcher
         */
        public function onLinkPathGeneration(FilterNodeSourcePathEvent $event, $eventName, EventDispatcherInterface $dispatcher)
        {
            $nodeSource = $event->getNodeSource();

            if ($nodeSource instanceof NSLink) {
                if (filter_var($nodeSource->getExternalUrl(), FILTER_VALIDATE_URL)) {
                    /*
                     * If editor linked to an external link
                     */
                    $event->stopPropagation();
                    $event->setComplete(true);
                    $event->setPath($nodeSource->getExternalUrl());
                } elseif (count($nodeSource->getNodeReferenceSources()) > 0 &&
                    null !== $linkedSource = $nodeSource->getNodeReferenceSources()[0]) {
                    /*
                     * If editor linked to an internal page through a node reference
                     */
                    /** @var FilterNodeSourcePathEvent $subEvent */
                    $subEvent = clone $event;
                    $subEvent->setNodeSource($linkedSource);
                    /*
                     * Dispatch a path generation again for linked node-source.
                     */
                    $dispatcher->dispatch(NodesSourcesEvents::NODE_SOURCE_PATH_GENERATING, $subEvent);
                    /*
                     * Fill main event with sub-event data
                     */
                    $event->setPath($subEvent->getPath());
                    $event->setComplete($subEvent->isComplete());
                    $event->setParameters($subEvent->getParameters());
                    // Stop propagation AFTER sub-event was dispatched not to prevent it to perform.
                    $event->stopPropagation();
                }
            }
        }
    }


Then register your subscriber to the Roadiz event dispatcher in your theme ``setupDependencyInjection``:

.. code-block:: php

    /** @var EventDispatcher $dispatcher */
    $dispatcher = $container['dispatcher'];
    $dispatcher->addSubscriber(new LinkPathGeneratingEventListener());

This method has an other great benefit: it allows your path logic to be cached inside node-source url’ cache
provider, instead of generating your custom URL inside your Twig templates or PHP controllers.

