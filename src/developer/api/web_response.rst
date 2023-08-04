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

Imagine you have a block (*ArticleFeedBlock*) which should list latest news (*Article*). You can use tree-walker mechanism to fetch latest news and
expose them as if they were children of your article feed block. This requires to create a custom definition:

..  code-block:: php

    <?php

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

Then create a definition factory which will be injected using Symfony autoconfigure tag ``roadiz_core.tree_walker_definition_factory``.

``roadiz_core.tree_walker_definition_factory`` tag must include a ``classname`` attribute which will be used to match your definition factory with the right node source class.

..  code-block:: php

    <?php

    declare(strict_types=1);

    namespace App\TreeWalker\Definition;

    use App\GeneratedEntity\NSArticleFeedBlock;
    use RZ\Roadiz\CoreBundle\Api\TreeWalker\Definition\DefinitionFactoryInterface;
    use RZ\TreeWalker\WalkerContextInterface;
    use Symfony\Component\DependencyInjection\Attribute\AutoconfigureTag;

    #[AutoconfigureTag(
        name:'roadiz_core.tree_walker_definition_factory',
        attributes: ['classname' => NSArticleFeedBlock::class]
    )]
    final class ArticleFeedBlockDefinitionFactory implements DefinitionFactoryInterface
    {
        public function create(WalkerContextInterface $context, bool $onlyVisible = true): callable
        {
            return new ArticleFeedBlockDefinition($context);
        }
    }

This way, all tree-walkers will be able to use your custom definition anytime a ``NSArticleFeedBlock`` is encountered.

You can debug all registered definition factories using ``bin/console debug:container --tag=roadiz_core.tree_walker_definition_factory`` command.

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

Then create you own custom resource to hold your menus tree-walkers and common content. Tree-walkers will be created using
``RZ\Roadiz\CoreBundle\Api\TreeWalker\TreeWalkerGenerator`` service.
TreeWalkerGenerator will create a ``App\TreeWalker\MenuNodeSourceWalker`` instance for each node source of type ``Menu`` located
on your website root.

..  code-block:: php

    <?php

    declare(strict_types=1);

    namespace App\Controller;

    use App\Api\Model\CommonContent;
    use App\TreeWalker\MenuNodeSourceWalker;
    use Doctrine\Persistence\ManagerRegistry;
    use RZ\Roadiz\Core\AbstractEntities\TranslationInterface;
    use RZ\Roadiz\CoreBundle\Api\Model\NodesSourcesHeadFactoryInterface;
    use RZ\Roadiz\CoreBundle\Api\TreeWalker\TreeWalkerGenerator;
    use RZ\Roadiz\CoreBundle\Preview\PreviewResolverInterface;
    use RZ\Roadiz\CoreBundle\Repository\TranslationRepository;
    use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
    use Symfony\Component\HttpFoundation\Request;
    use Symfony\Component\HttpFoundation\RequestStack;
    use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
    use Symfony\Component\Routing\Exception\ResourceNotFoundException;

    final class GetCommonContentController extends AbstractController
    {
        private RequestStack $requestStack;
        private ManagerRegistry $managerRegistry;
        private NodesSourcesHeadFactoryInterface $nodesSourcesHeadFactory;
        private PreviewResolverInterface $previewResolver;
        private TreeWalkerGenerator $treeWalkerGenerator;

        public function __construct(
            RequestStack $requestStack,
            ManagerRegistry $managerRegistry,
            NodesSourcesHeadFactoryInterface $nodesSourcesHeadFactory,
            PreviewResolverInterface $previewResolver,
            TreeWalkerGenerator $treeWalkerGenerator
        ) {
            $this->requestStack = $requestStack;
            $this->managerRegistry = $managerRegistry;
            $this->nodesSourcesHeadFactory = $nodesSourcesHeadFactory;
            $this->previewResolver = $previewResolver;
            $this->treeWalkerGenerator = $treeWalkerGenerator;
        }

        public function __invoke(): ?CommonContent
        {
            try {
                $request = $this->requestStack->getMainRequest();
                $translation = $this->getTranslationFromRequest($request);

                $resource = new CommonContent();

                $request?->attributes->set('data', $resource);
                $resource->head = $this->nodesSourcesHeadFactory->createForTranslation($translation);
                $resource->home = $resource->head->getHomePage();
                $resource->menus = $this->treeWalkerGenerator->getTreeWalkersForTypeAtRoot(
                    'Menu',
                    MenuNodeSourceWalker::class,
                    $translation,
                    3
                );
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
            $repository = $this->managerRegistry->getRepository(TranslationInterface::class);
            if (!$repository instanceof TranslationRepository) {
                throw new \RuntimeException(
                    'Translation repository must be instance of ' .
                    TranslationRepository::class
                );
            }
            return $repository;
        }
    }


Then, the following resource will be exposed:

..  code-block:: json

    {
        "@context": "/api/contexts/CommonContent",
        "@id": "/api/common_content",
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
        "menus": {
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
            }
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
