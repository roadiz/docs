.. _serialization:

Serialization
=============

*Roadiz* CMS uses ``jms/serializer`` to perform JSON serialization over any objects, especially *Doctrine* entities.

.. code-block:: php

    $response = new JsonResponse(
        $this->get('serializer')->serialize(
            $this->getNodeSource(),
            'json',
            SerializationContext::create()->setGroups(['nodes_sources', 'urls', 'walker', 'children'])
        ),
        Response::HTTP_OK,
        [],
        true
    );

Customize existing serialized entities
--------------------------------------

Serialize nodes-sources URL
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Your can add data in your serialized data from your themes using ``EventSubscriberInterface`` listening
on ``serializer.post_serialize`` event. For example, you may want to get your *reachable* ``NodesSources`` URL in their
JSON response. Here is how to do:

.. code-block:: php

    <?php
    declare(strict_types=1);

    namespace Themes\MyAwesomeTheme\Serialization;

    use JMS\Serializer\EventDispatcher\EventSubscriberInterface;
    use JMS\Serializer\EventDispatcher\ObjectEvent;
    use JMS\Serializer\Metadata\StaticPropertyMetadata;
    use JMS\Serializer\Visitor\SerializationVisitorInterface;
    use Pimple\Container;
    use RZ\Roadiz\Core\ContainerAwareInterface;
    use RZ\Roadiz\Core\ContainerAwareTrait;
    use RZ\Roadiz\Core\Entities\NodesSources;
    use Symfony\Cmf\Component\Routing\RouteObjectInterface;
    use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

    final class NodesSourcesUriSubscriber implements EventSubscriberInterface, ContainerAwareInterface
    {
        use ContainerAwareTrait;

        /**
         * DocumentUriSubscriber constructor.
         *
         * @param Container $container
         */
        public function __construct(Container $container)
        {
            $this->container = $container;
        }

        /**
         * @inheritDoc
         */
        public static function getSubscribedEvents()
        {
            return [[
                'event' => 'serializer.post_serialize',
                'method' => 'onPostSerialize',
            ]];
        }

        /**
         * @param ObjectEvent $event
         * @return void
         */
        public function onPostSerialize(ObjectEvent $event)
        {
            $nodeSource = $event->getObject();
            $visitor = $event->getVisitor();
            $context = $event->getContext();

            if ($context->hasAttribute('groups') &&
                in_array('urls', $context->getAttribute('groups'))) {
                /** @var UrlGeneratorInterface $urlGenerator */
                $urlGenerator = $this->get('urlGenerator');
                if ($nodeSource instanceof NodesSources &&
                    null !== $nodeSource->getNode() &&
                    null !== $nodeSource->getNode()->getNodeType() &&
                    $visitor instanceof SerializationVisitorInterface &&
                    $nodeSource->getNode()->isPublished() &&
                    $nodeSource->getNode()->getNodeType()->isReachable()
                ) {
                    $visitor->visitProperty(
                        new StaticPropertyMetadata('string', 'url', []),
                        $urlGenerator->generate(
                            RouteObjectInterface::OBJECT_BASED_ROUTE_NAME,
                            [
                                RouteObjectInterface::ROUTE_OBJECT => $nodeSource
                            ],
                            UrlGeneratorInterface::ABSOLUTE_URL
                        )
                    );
                }
            }
        }
    }


Then register your ``NodesSourcesUriSubscriber`` in your theme services:

.. code-block:: php

    $container->extend('serializer.subscribers', function (array $subscribers, Container $c) {
        $subscribers[] = new NodesSourcesUriSubscriber($c);
        return $subscribers;
    });

Then your JSON response will contain the additional key ``url`` :

.. code-block:: json

    {
        …
        "url": "http://myawesomesite.test/about-us"
    }

You can add every piece of data in your serialized responses, even node children by injecting a *tree-walker*.

Serialize documents URL
^^^^^^^^^^^^^^^^^^^^^^^

Same way for injecting your document URL (i.e. image path, or iframe source), we need to call Roadiz document URL
generator for any Document serialized into our JSON response:

.. code-block:: php

    <?php
    declare(strict_types=1);

    namespace Themes\MyAwesomeTheme\Serialization;

    use JMS\Serializer\EventDispatcher\EventSubscriberInterface;
    use JMS\Serializer\EventDispatcher\ObjectEvent;
    use JMS\Serializer\Metadata\StaticPropertyMetadata;
    use JMS\Serializer\Visitor\SerializationVisitorInterface;
    use Pimple\Container;
    use RZ\Roadiz\Core\ContainerAwareInterface;
    use RZ\Roadiz\Core\ContainerAwareTrait;
    use RZ\Roadiz\Core\Entities\Document;
    use RZ\Roadiz\Core\Exceptions\InvalidEmbedId;
    use RZ\Roadiz\Utils\MediaFinders\EmbedFinderFactory;
    use RZ\Roadiz\Utils\UrlGenerators\DocumentUrlGenerator;

    final class DocumentUriSubscriber implements EventSubscriberInterface, ContainerAwareInterface
    {
        use ContainerAwareTrait;

        /**
         * DocumentUriSubscriber constructor.
         *
         * @param Container $container
         */
        public function __construct(Container $container)
        {
            $this->container = $container;
        }

        /**
         * @inheritDoc
         */
        public static function getSubscribedEvents()
        {
            return [[
                'event' => 'serializer.post_serialize',
                'method' => 'onPostSerialize',
                'class' => Document::class,
            ]];
        }

        /**
         * @param ObjectEvent $event
         * @return void
         */
        public function onPostSerialize(ObjectEvent $event)
        {
            $document = $event->getObject();
            $visitor = $event->getVisitor();
            $context = $event->getContext();

            if (null !== $this->container &&
                $context->hasAttribute('groups') &&
                in_array('urls', $context->getAttribute('groups'))) {
                /** @var DocumentUrlGenerator $urlGenerator */
                $urlGenerator = $this->get('document.url_generator')->setDocument($document);

                if ($document instanceof Document &&
                    $visitor instanceof SerializationVisitorInterface) {
                    $urls = [];
                    if ($document->isEmbed() && $document->getEmbedId()) {
                        try {
                            /** @var EmbedFinderFactory $embedFinderFactory */
                            $embedFinderFactory = $this->get(EmbedFinderFactory::class);
                            if (null !== $document->getEmbedPlatform() &&
                                $embedFinderFactory->supports($document->getEmbedPlatform())) {
                                $embedFinder = $embedFinderFactory->createForPlatform(
                                    $document->getEmbedPlatform(),
                                    $document->getEmbedId()
                                );
                                if (null !== $embedFinder) {
                                    $urls['embed'] = $embedFinder->getSource();
                                }
                            }
                        } catch (InvalidEmbedId $embedException) {
                        }
                    }
                    if ($document->isProcessable()) {
                        $visitor->visitProperty(
                            new StaticPropertyMetadata('array', 'urls', []),
                            array_merge($urls, [
                                'original' => $urlGenerator->setOptions([
                                    'noProcess' => true,
                                ])->getUrl(true)
                            ], $this->getSizes($urlGenerator))
                        );
                    } else {
                        if ($document->hasThumbnails()) {
                            $thumbnail = $document->getThumbnails()->first();
                            if ($thumbnail instanceof Document && $thumbnail->isProcessable()) {
                                /** @var DocumentUrlGenerator $thumbUrlGenerator */
                                $thumbUrlGenerator = $this->get('document.url_generator')->setDocument($thumbnail);
                                $urls = array_merge($urls, $this->getSizes($thumbUrlGenerator));
                            }
                        }
                        $visitor->visitProperty(
                            new StaticPropertyMetadata('array', 'urls', []),
                            array_merge($urls, [
                                'original' => $urlGenerator->setOptions([
                                    'noProcess' => true
                                ])->getUrl(true),
                            ])
                        );
                    }
                }
            }
        }

        protected function getSizes(DocumentUrlGenerator $generator): array
        {
            return [];
        }
    }



Groups
------

.. glossary::

    id
        Serialize every entity ``id``.

    timestamps
        Serialize every date-timed entity ``createdAt`` and ``updatedAt`` fields.

    position
        Serialize every entity ``position`` fields.

    color
        Serialize every entity ``color`` fields.

    nodes_sources
        Serialize entities in a ``NodesSources`` context (all fields).

    nodes_sources_base
        Serialize entities in a ``NodesSources`` context, but with essential information.

    nodes_sources_documents
        Serialize documents linked to a ``NodesSources`` for each virtual field.

    nodes_sources_default
        Serialize ``NodesSources`` fields not contained in any **group**.

    nodes_sources_``group``
        Custom serialization groups are created according to your node-typ fields groups.
        For example, if you set a field to a ``link`` group, ``nodes_sources_link`` serialization
        group will be automatically generated for this field. *Be careful*, Roadiz will use groups
        *canonical names* to generate serialization groups, it can mix ``_`` and ``-``.

    node
        Serialize entities in a ``Node`` context.

    tag
        Serialize entities in a ``Tag`` context.

    tag_base
        Serialize entities in a ``Tag`` context.

    node_type
        Serialize entities in a ``NodeType`` context.

    attribute
        Serialize entities in a ``Attribute`` context.

    custom_form
        Serialize entities in a ``CustomForm`` context.

    document
        Serialize entities in a ``Document`` context.

    folder
        Serialize entities in a ``Folder`` context.

    translation
        Serialize entities in a ``Translation`` context.

    setting
        Serialize entities in a ``Setting`` context.

    setting_group
        Serialize entities in a ``SettingGroup`` context.

