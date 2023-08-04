.. _web_response:


WebResponse concept
===================

A REST-ful API will expose collection and item entry-points for each resource. But in both case, you need to know your
resource type or your resource identifier **before** executing your API call.
Roadiz introduces a special resource named **WebResponse** which can be called using a ``path`` query param in order
to reduce as much as possible API calls and address `N+1 problem <https://restfulapi.net/rest-api-n-1-problem/>`_.

.. code-block:: http

    GET /api/web_response_by_path?path=/contact

API will expose a WebResponse single item containing:

* An item
* Item breadcrumbs
* Head object
* Item blocks tree-walker
* Item realms
* and if blocks are hidden by Realm configuration

.. note::

    Roadiz *WebResponse* is used in `Rezo Zero Nuxt Starter <https://github.com/rezozero/nuxt-starter#dynamic-page-data-based-on-requestpath>`_
    to populate all data during the ``asyncData()`` routine in ``_.vue`` page

.. code-block:: json

    {
        "@context": "/api/contexts/WebResponse",
        "@id": "/api/web_response_by_path?path=/contact",
        "@type": "WebResponse",
        "item": {
            "@id": "/api/pages/7",
            "@type": "Page",
            "content": "Magni deleniti ut eveniet. Aliquam aut et excepturi vitae placeat molestiae. Molestiae asperiores nihil sed temporibus quibusdam. Non magnam fuga at. sdf",
            "subTitle": null,
            "overTitle": null,
            "headerImage": [],
            "test": null,
            "pictures": [],
            "nodeReferences": [],
            "stickytest": false,
            "sticky": false,
            "customForm": [],
            "title": "Contact",
            "publishedAt": "2021-09-10T15:56:00+02:00",
            "metaTitle": "",
            "metaKeywords": "",
            "metaDescription": "",
            "users": [],
            "node": {
                "@type": "Node",
                "@id": "/api/nodes/7",
                "visible": true,
                "position": 3,
                "tags": []
            },
            "slug": "contact",
            "url": "/contact"
        },
        "breadcrumbs": {
            "@type": "Breadcrumbs",
            "@id": "_:14750",
            "items": []
        },
        "head": {
            "@type": "NodesSourcesHead",
            "@id": "_:14679",
            "googleAnalytics": null,
            "googleTagManager": null,
            "matomoUrl": null,
            "matomoSiteId": null,
            "siteName": "Roadiz dev website",
            "metaTitle": "Contact – Roadiz dev website",
            "metaDescription": "Contact, Roadiz dev website",
            "policyUrl": null,
            "mainColor": null,
            "facebookUrl": null,
            "instagramUrl": null,
            "twitterUrl": null,
            "youtubeUrl": null,
            "linkedinUrl": null,
            "homePageUrl": "/",
            "shareImage": null
        },
        "blocks": [],
        "realms": [],
        "hidingBlocks": false
    }


Override WebResponse block walker
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Imagine you have a block (*ArticleFeedBlock*) which should list latest news (*Article*). You can use TreeWalker mechanism to fetch latest news and
expose them as children of your block. This would require to create a custom TreeWalker definition:

..  code-block:: php

    <?php

    # src/TreeWalker/Definition/ArticleFeedBlockDefinition.php
    declare(strict_types=1);

    namespace App\TreeWalker\Definition;

    use App\GeneratedEntity\NSArticle;
    use App\GeneratedEntity\NSArticleFeedBlock;
    use Doctrine\ORM\Tools\Pagination\Paginator;
    use RZ\Roadiz\CoreBundle\Api\TreeWalker\NodeSourceWalkerContext;
    use RZ\Roadiz\CoreBundle\Entity\NodesSources;
    use RZ\TreeWalker\Definition\ContextualDefinitionTrait;
    use RZ\TreeWalker\Definition\StoppableDefinition;
    use RZ\TreeWalker\WalkerInterface;

    final class ArticleFeedBlockDefinition implements StoppableDefinition
    {
        use ContextualDefinitionTrait;

        public function isStoppingCollectionOnceInvoked(): bool
        {
            return true;
        }

        /**
         * @param NodesSources $source
         * @param WalkerInterface $walker
         * @return array
         * @throws \Exception
         */
        public function __invoke(NodesSources $source, WalkerInterface $walker): array
        {
            if ($this->context instanceof NodeSourceWalkerContext) {
                $this->context->getStopwatch()->start(self::class);
                if (!$source instanceof NSArticleFeedBlock) {
                    throw new \InvalidArgumentException('Source must be instance of ' . NSArticleFeedBlock::class);
                }

                $criteria = [
                    'node.visible' => true,
                    'publishedAt' => ['<=', new \DateTime()],
                    'translation' => $source->getTranslation(),
                    'node.nodeType' => $this->context->getNodeTypesBag()->get('Article')
                ];

                // Prevent Article feed to list root Article again
                $root = $walker->getRoot()->getItem();
                if ($root instanceof NSArticle) {
                    $criteria['id'] = ['!=', $root->getId()];
                }

                if (null !== $source->getNode() && \count($source->getNode()->getTags()) > 0) {
                    $criteria['tags'] = $source->getNode()->getTags();
                    $criteria['tagExclusive'] = true;
                }

                $count = (int) ($source->getListingCount() ?? 4);

                $children = $this->context->getNodeSourceApi()->getBy($criteria, [
                    'publishedAt' => 'DESC'
                ], $count);


                if ($children instanceof Paginator) {
                    $iterator = $children->getIterator();
                    if ($iterator instanceof \ArrayIterator) {
                        $children = $iterator->getArrayCopy();
                    } else {
                        throw new \RuntimeException('Unexpected iterator type');
                    }
                }

                $this->context->getStopwatch()->stop(self::class);

                return $children;
            }
            throw new \InvalidArgumentException('Context should be instance of ' . NodeSourceWalkerContext::class);
        }
    }

And register it in a new ``AutoChildrenWalker`` class which extends default ``RZ\Roadiz\CoreBundle\Api\TreeWalker\AutoChildrenNodeSourceWalker``:

..  code-block:: php

    <?php

    # src/TreeWalker/AppAutoChildrenWalker.php
    declare(strict_types=1);

    namespace App\TreeWalker;

    use App\GeneratedEntity\NSArticleFeedBlock;
    use App\TreeWalker\Definition\ArticleFeedBlockDefinition;
    use RZ\Roadiz\CoreBundle\Api\TreeWalker\AutoChildrenNodeSourceWalker;

    final class AppAutoChildrenWalker extends AutoChildrenNodeSourceWalker
    {
        protected function initializeAdditionalDefinitions(): void
        {
            parent::initializeAdditionalDefinitions();

            $this->addDefinition(
                NSArticleFeedBlock::class,
                new ArticleFeedBlockDefinition($this->getContext())
            );
        }
    }


Then you'll need to register your custom ``AppAutoChildrenWalker`` for your ``/api/web_response_by_path`` endpoint:

You can override WebResponse block walker class by creating a custom ``App\Api\DataTransformer\WebResponseDataTransformer`` class
which extends ``RZ\Roadiz\CoreBundle\Api\DataTransformer\WebResponseOutputDataTransformer``.

..  code-block:: php

    <?php

    declare(strict_types=1);

    namespace App\Api\DataTransformer;

    use App\TreeWalker\AppAutoChildrenWalker;
    use RZ\Roadiz\CoreBundle\Api\DataTransformer\WebResponseOutputDataTransformer;

    final class WebResponseDataTransformer extends WebResponseOutputDataTransformer
    {
        protected function getChildrenNodeSourceWalkerClassname(): string
        {
            return AppAutoChildrenWalker::class;
        }
    }

Then register your custom class in your ``config/services.yaml`` file to override default WebResponse data transformer:

..  code-block:: yaml

    # config/services.yaml
    services:
        RZ\Roadiz\CoreBundle\Api\DataTransformer\WebResponseOutputDataTransformer:
        class: App\Api\DataTransformer\WebResponseDataTransformer



Retrieve common content
-----------------------

Now that we can fetch each page data, we need to get all unique content for building Menus, Homepage reference, headers, footers, etc.
We could extend our _WebResponse_ to inject theses common data to each request, but it would bloat HTTP responses, and
affect API performances.

For these common content, you can create a ``/api/common_content`` API endpoint in your project which will fetched only once in your
frontend application.

..  code-block:: yaml

    # config/api_resources/common_content.yml

    App\Api\Model\CommonContent:
        collectionOperations: {}
        itemOperations:
            getCommonContent:
                method: 'GET'
                path: '/common_content'
                read: false
                controller: App\Controller\GetCommonContentController
                pagination_enabled: false
                normalization_context:
                    pagination_enabled: false
                    groups:
                        - get
                        - common_content
                        - web_response
                        - walker
                        - walker_level
                        - children
                        - children_count
                        - nodes_sources_base
                        - nodes_sources_default
                        - urls
                        - tag_base
                        - translation_base
                        - document_display

Then create you own custom resource to hold your menus tree-walkers and common content:

..  code-block:: php

    <?php

    declare(strict_types=1);

    namespace App\Controller;

    use App\Model\CommonContent;
    use App\TreeWalker\MenuNodeSourceWalker;
    use Doctrine\Persistence\ManagerRegistry;
    use Psr\Cache\CacheItemPoolInterface;
    use RZ\Roadiz\CoreBundle\Api\Model\NodesSourcesHeadFactoryInterface;
    use RZ\Roadiz\Core\AbstractEntities\TranslationInterface;
    use RZ\Roadiz\CoreBundle\Api\TreeWalker\AutoChildrenNodeSourceWalker;
    use RZ\Roadiz\CoreBundle\Bag\Settings;
    use RZ\Roadiz\CoreBundle\EntityApi\NodeSourceApi;
    use RZ\Roadiz\CoreBundle\Preview\PreviewResolverInterface;
    use RZ\Roadiz\CoreBundle\Repository\TranslationRepository;
    use RZ\TreeWalker\WalkerContextInterface;
    use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
    use Symfony\Component\HttpFoundation\Request;
    use Symfony\Component\HttpFoundation\RequestStack;
    use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
    use Symfony\Component\Routing\Exception\ResourceNotFoundException;

    final class GetCommonContentController extends AbstractController
    {
        private RequestStack $requestStack;
        private ManagerRegistry $managerRegistry;
        private WalkerContextInterface $walkerContext;
        private Settings $settingsBag;
        private NodeSourceApi $nodeSourceApi;
        private CacheItemPoolInterface $cacheItemPool;
        private NodesSourcesHeadFactoryInterface $nodesSourcesHeadFactory;
        private PreviewResolverInterface $previewResolver;

        public function __construct(
            RequestStack $requestStack,
            ManagerRegistry $managerRegistry,
            WalkerContextInterface $walkerContext,
            Settings $settingsBag,
            NodeSourceApi $nodeSourceApi,
            NodesSourcesHeadFactoryInterface $nodesSourcesHeadFactory,
            CacheItemPoolInterface $cacheItemPool,
            PreviewResolverInterface $previewResolver
        ) {
            $this->requestStack = $requestStack;
            $this->walkerContext = $walkerContext;
            $this->cacheItemPool = $cacheItemPool;
            $this->nodeSourceApi = $nodeSourceApi;
            $this->managerRegistry = $managerRegistry;
            $this->nodesSourcesHeadFactory = $nodesSourcesHeadFactory;
            $this->settingsBag = $settingsBag;
            $this->previewResolver = $previewResolver;
        }

        public function __invoke(): ?CommonContent
        {
            try {
                $request = $this->requestStack->getMainRequest();
                $translation = $this->getTranslationFromRequest($request);
                $home = $this->nodeSourceApi->getOneBy([
                    'node.home' => true,
                    'translation' => $translation
                ]);
                $mainMenu = $this->nodeSourceApi->getOneBy([
                    'node.nodeName' => 'main-menu',
                    'translation' => $translation
                ]);
                $footerMenu = $this->nodeSourceApi->getOneBy([
                    'node.nodeName' => 'footer-menu',
                    'translation' => $translation
                ]);
                $errorPage = $this->nodeSourceApi->getOneBy([
                    'node.nodeName' => 'error-page',
                    'translation' => $translation
                ]);

                $resource = new CommonContent();

                if (null !== $home) {
                    $resource->home = $home;
                }
                if (null !== $mainMenu) {
                    $resource->mainMenuWalker = MenuNodeSourceWalker::build(
                        $mainMenu,
                        $this->walkerContext,
                        3,
                        $this->cacheItemPool
                    );
                }
                if (null !== $footerMenu) {
                    $resource->footerMenuWalker = MenuNodeSourceWalker::build(
                        $footerMenu,
                        $this->walkerContext,
                        3,
                        $this->cacheItemPool
                    );
                }
                if (null !== $footer) {
                    $resource->footerWalker = AutoChildrenNodeSourceWalker::build(
                        $footer,
                        $this->walkerContext,
                        3,
                        $this->cacheItemPool
                    );
                }
                if (null !== $errorPage) {
                    $resource->errorPageWalker = AutoChildrenNodeSourceWalker::build(
                        $errorPage,
                        $this->walkerContext,
                        3,
                        $this->cacheItemPool
                    );
                }
                if (null !== $request) {
                    $request->attributes->set('data', $resource);
                }
                $resource->head = $this->nodesSourcesHeadFactory->createForTranslation($translation);
                return $resource;
            } catch (ResourceNotFoundException $exception) {
                throw new NotFoundHttpException($exception->getMessage(), $exception);
            }
        }

        protected function getTranslationFromRequest(?Request $request): TranslationInterface
        {
            $locale = null;

            if (null !== $request) {
                $locale = $request->query->get('_locale');

                /*
                 * If no _locale query param is defined check Accept-Language header
                 */
                if (null === $locale) {
                    $locale = $request->getPreferredLanguage($this->getTranslationRepository()->getAllLocales());
                }
            }
            /*
             * Then fallback to default CMS locale
             */
            if (null === $locale) {
                $translation = $this->getTranslationRepository()->findDefault();
            } elseif ($this->previewResolver->isPreview()) {
                $translation = $this->getTranslationRepository()
                    ->findOneByLocaleOrOverrideLocale((string) $locale);
            } else {
                $translation = $this->getTranslationRepository()
                    ->findOneAvailableByLocaleOrOverrideLocale((string) $locale);
            }
            if (null === $translation) {
                throw new NotFoundHttpException('No translation for locale ' . $locale);
            }
            return $translation;
        }

        protected function getTranslationRepository(): TranslationRepository
        {
            return $this->managerRegistry->getRepository(TranslationInterface::class);
        }
    }

Then, the following resource will be exposed:

..  code-block:: json

    {
        "@context": "/api/contexts/CommonContent",
        "@id": "/api/common_content?id=unique",
        "@type": "CommonContent",
        "home": {
            "@id": "/api/pages/11",
            "@type": "Page",
            "content": null,
            "image": [],
            "title": "Accueil",
            "publishedAt": "2022-04-12T16:24:00+02:00",
            "node": {
                "@type": "Node",
                "@id": "/api/nodes/10",
                "visible": true,
                "tags": []
            },
            "slug": "accueil",
            "url": "/fr"
        },
        "mainMenuWalker": {
            "@type": "MenuNodeSourceWalker",
            "@id": "_:3341",
            "children": [],
            "childrenCount": 0,
            "item": {
                "@id": "/api/menus/2",
                "@type": "Menu",
                "title": "Menu principal",
                "publishedAt": "2022-04-12T00:39:00+02:00",
                "node": {
                    "@type": "Node",
                    "@id": "/api/nodes/1",
                    "visible": false,
                    "tags": []
                },
                "slug": "main-menu"
            },
            "level": 0,
            "maxLevel": 3
        },
        "footerMenuWalker": {
            "@type": "MenuNodeSourceWalker",
            "@id": "_:2381",
            "children": [],
            "childrenCount": 0,
            "item": {
                "@id": "/api/menus/3",
                "@type": "Menu",
                "linkInternalReference": [],
                "title": "Menu du pied de page",
                "publishedAt": "2022-04-12T11:18:12+02:00",
                "node": {
                    "@type": "Node",
                    "@id": "/api/nodes/2",
                    "visible": false,
                    "tags": []
                },
                "slug": "footer-menu"
            },
            "level": 0,
            "maxLevel": 3
        },
        "footerWalker": {
            "@type": "AutoChildrenNodeSourceWalker",
            "@id": "_:2377",
            "children": [],
            "childrenCount": 0,
            "item": {
                "@id": "/api/footers/16",
                "@type": "Footer",
                "content": "",
                "title": "Pied de page",
                "publishedAt": "2022-04-12T19:02:47+02:00",
                "node": {
                    "@type": "Node",
                    "@id": "/api/nodes/15",
                    "visible": false,
                    "tags": []
                },
                "slug": "footer"
            },
            "level": 0,
            "maxLevel": 3
        },
        "errorPageWalker": {
            "@type": "AutoChildrenNodeSourceWalker",
            "@id": "_:3465",
            "children": [],
            "childrenCount": 0,
            "item": {
                "@id": "/api/pages/153",
                "@type": "Page",
                "title": "Page d'erreur",
                "publishedAt": "2022-05-12T17:16:40+02:00",
                "node": {
                    "@type": "Node",
                    "@id": "/api/nodes/146",
                    "visible": false,
                    "tags": []
                },
                "slug": "error-page",
                "url": "/fr/error-page"
            },
            "level": 0,
            "maxLevel": 3
        },
        "head": {
            "@type": "NodesSourcesHead",
            "@id": "_:14679",
            "googleAnalytics": null,
            "googleTagManager": null,
            "matomoUrl": null,
            "matomoSiteId": null,
            "siteName": "Roadiz dev website",
            "metaTitle": "Contact – Roadiz dev website",
            "metaDescription": "Contact, Roadiz dev website",
            "policyUrl": null,
            "mainColor": null,
            "facebookUrl": null,
            "instagramUrl": null,
            "twitterUrl": null,
            "youtubeUrl": null,
            "linkedinUrl": null,
            "homePageUrl": "/",
            "shareImage": null
        }
    }
