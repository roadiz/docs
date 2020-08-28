.. _extending_solr:

Extending Solr indexation
-------------------------


How to index page blocks contents
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If all your text content is written in *block nodes* instead of reachable *pages*, you should index them
into your page Solr documents to improve your search engine relevancy.

You can use the ``NodesSourcesIndexingEvent::class`` event to enhance your node indexing data before
it’s persisted into *Solr* engine (especially ``collection_txt`` field):

.. code-block:: php

    <?php
    declare(strict_types=1);

    namespace Themes\MyTheme\Event;

    use GeneratedNodeSources\NSGroupBlock;
    use GeneratedNodeSources\NSPage;
    use Pimple\Container;
    use RZ\Roadiz\Core\Entities\NodesSources;
    use RZ\Roadiz\Core\Events\NodesSources\NodesSourcesIndexingEvent;
    use RZ\Roadiz\Core\SearchEngine\SolariumFactoryInterface;
    use RZ\Roadiz\Core\SearchEngine\SolariumNodeSource;
    use Symfony\Component\EventDispatcher\EventSubscriberInterface;

    final class PageIndexingEventSubscriber implements EventSubscriberInterface
    {
        /**
         * @var Container
         */
        protected $container;

        public function __construct(Container $container)
        {
            $this->container = $container;
        }

        /**
         * @inheritDoc
         */
        public static function getSubscribedEvents()
        {
            return [
                NodesSourcesIndexingEvent::class => ['onIndexing'],
            ];
        }

        public function onIndexing(NodesSourcesIndexingEvent $event)
        {
            $nodeSource = $event->getNodeSource();
            if ($nodeSource instanceof NSPage || $nodeSource instanceof NSGroupBlock) {
                $assoc = $event->getAssociations();

                /*
                 * Fetch every non-reachable blocks
                 * to gather their text content in master page document
                 */
                $children = $this->container['nodeSourceApi']->getBy([
                    'node.nodeType.reachable' => false,
                    'node.visible' => true,
                    'translation' => $nodeSource->getTranslation(),
                    'node.parent' => $nodeSource->getNode(),
                ]);

                /** @var NodesSources $child */
                foreach ($children as $child) {
                    /** @var SolariumNodeSource $solarium */
                    $solarium = $this->container[SolariumFactoryInterface::class]->createWithNodesSources($child);
                    // Fetch all fields array association AS sub-resources (i.e. do not index their title)
                    $childAssoc = $solarium->getFieldsAssoc(true);
                    $assoc['collection_txt'] = array_merge(
                        $assoc['collection_txt'],
                        $childAssoc['collection_txt']
                    );
                }

                $event->setAssociations($assoc);
            }
        }
    }

Then register this subscriber to your event-dispatcher:

.. code-block:: php

    # In your theme ServiceProvider…
    $container->extend('dispatcher', function (EventDispatcherInterface $dispatcher, Container $c) {
        $dispatcher->addSubscriber(new PageIndexingEventSubscriber($c));
        return $dispatcher;
    });
