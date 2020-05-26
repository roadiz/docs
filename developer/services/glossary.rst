.. _services_list:

Services list
-------------

Here is the current list of Roadiz services registered into ``Kernel`` container. These can be overridden or used from any Controller with ``$this->get()`` method.

Kernel
^^^^^^

.. glossary::

    stopwatch
        ``Symfony\Component\Stopwatch\Stopwatch``

    kernel
        ``RZ\Roadiz\Core\Kernel``

    dispatcher
        ``Symfony\Component\EventDispatcher\EventDispatcher``

Assets
^^^^^^
.. glossary::

    versionStrategy
        ``Symfony\Component\Asset\VersionStrategy\EmptyVersionStrategy``

    interventionRequestSupportsWebP
        ``bool``

    interventionRequestConfiguration
        ``AM\InterventionRequest\Configuration``

    interventionRequestSubscribers
        ``array``

    interventionRequestLogger
        ``Monolog\Logger``

    interventionRequest
        ``AM\InterventionRequest\InterventionRequest``

    assetPackages
        ``RZ\Roadiz\Utils\Asset\Packages``

Back-office
^^^^^^^^^^^

.. glossary::

    backoffice.entries
        ``array``

Bags
^^^^
.. glossary::

    settingsBag
        ``RZ\Roadiz\Core\Bags\Settings``

    rolesBag
        ``RZ\Roadiz\Core\Bags\Roles``

    nodeTypesBag
        ``RZ\Roadiz\Core\Bags\NodeTypes``

Console
^^^^^^^

.. glossary::

    console.commands
        ``array``

Debug
^^^^^^^

.. glossary::

    messagescollector
        ``DebugBar\DataCollector\MessagesCollector``

    doctrine.debugstack
        ``Doctrine\DBAL\Logging\DebugStack``

    debugbar
        ``RZ\Roadiz\Utils\DebugBar\RoadizDebugBar``

    debugbar.renderer
        ``DebugBar\JavascriptRenderer``

Doctrine
^^^^^^^^

.. glossary::

    doctrine.relative_entities_paths
        ``array``

    doctrine.entities_paths
        ``array``

    em.config
        ``Doctrine\ORM\Configuration``

    em
        ``Doctrine\ORM\EntityManager``, you can access it using ``$this->get(EntityManagerInterface::class)``.

    em.eventSubscribers
        ``array``

    nodesSourcesUrlCacheProvider
        ``Doctrine\Common\Cache\CacheProvider``

    CacheProvider::class
         :sup:`Factory` Creates a ``CacheProvider::class`` using Roadiz configuration, , you can access it using ``$this->get(CacheProvider::class)``.

Embed documents
^^^^^^^^^^^^^^^

.. glossary::

    document.platforms
        ``array``

    embed_finder.youtube
        :sup:`Factory` ``RZ\Roadiz\Utils\MediaFinders\YoutubeEmbedFinder``

    embed_finder.vimeo
        :sup:`Factory` ``RZ\Roadiz\Utils\MediaFinders\VimeoEmbedFinder``

    embed_finder.dailymotion
        :sup:`Factory` ``RZ\Roadiz\Utils\MediaFinders\DailymotionEmbedFinder``

    embed_finder.soundcloud
        :sup:`Factory` ``RZ\Roadiz\Utils\MediaFinders\SoundcloudEmbedFinder``

    embed_finder.mixcloud
        :sup:`Factory` ``RZ\Roadiz\Utils\MediaFinders\MixcloudEmbedFinder``

    embed_finder.spotify
        :sup:`Factory` ``RZ\Roadiz\Utils\MediaFinders\SpotifyEmbedFinder``

    embed_finder.ted
        :sup:`Factory` ``RZ\Roadiz\Utils\MediaFinders\TedEmbedFinder``

    embed_finder.twitch
        :sup:`Factory` ``RZ\Roadiz\Utils\MediaFinders\TwitchEmbedFinder``

Entity Api
^^^^^^^^^^

.. glossary::

    nodeApi
        ``RZ\Roadiz\CMS\Utils\NodeApi``

    nodeTypeApi
        ``RZ\Roadiz\CMS\Utils\NodeTypeApi``

    nodeSourceApi
        ``RZ\Roadiz\CMS\Utils\NodeSourceApi``

    tagApi
        ``RZ\Roadiz\CMS\Utils\TagApi``


Factories
^^^^^^^^^

.. glossary::

    emailManager
        :sup:`Factory` ``RZ\Roadiz\Utils\EmailManager``

    contactFormManager
        :sup:`Factory` ``RZ\Roadiz\Utils\ContactFormManager``

    NodeFactory::class
        ``RZ\Roadiz\Utils\Node\NodeFactory``. Factory to create new nodes from a title, a node-type and translation.

    TagFactory::class
        ``RZ\Roadiz\Utils\Tag\TagFactory``. Factory to create new tags from a title, a parent tag and a translation.

    factory.handler
        ``RZ\Roadiz\Core\Handlers\HandlerFactory``
        Creates any Handler based on entity class.

    node.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\NodeHandler``

    nodes_sources.handler
       :sup:`Factory`  ``RZ\Roadiz\Core\Handlers\NodesSourcesHandler``

    node_type.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\NodeTypeHandler``

    node_type_field.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\NodeTypeFieldHandler``

    document.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\DocumentHandler``

    custom_form.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\CustomFormHandler``

    custom_form_field.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\CustomFormFieldHandler``

    folder.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\FolderHandler``

    font.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\FontHandler``

    group.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\GroupHandler``

    newsletter.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\NewsletterHandler``

    tag.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\TagHandler``

    translation.handler
        :sup:`Factory` ``RZ\Roadiz\Core\Handlers\TranslationHandler``

    document.viewer
        :sup:`Factory` ``RZ\Roadiz\Core\Viewers\DocumentViewer``

    translation.viewer
        :sup:`Factory` ``RZ\Roadiz\Core\Viewers\TranslationViewer``

    user.viewer
        :sup:`Factory` ``RZ\Roadiz\Core\Viewers\UserViewer``

    document.url_generator
        :sup:`Factory` ``RZ\Roadiz\Utils\UrlGenerators\DocumentUrlGenerator``

    document.factory
        :sup:`Factory` ``RZ\Roadiz\Utils\Document\DocumentFactory``

Forms
^^^^^

.. glossary::

    formValidator
        ``Symfony\Component\Form\Validator\ValidatorInterface``

    formFactory
        ``Symfony\Component\Form\FormFactoryInterface``

    form.extensions
        ``array``

    form.type.extensions
        ``array``

    Rollerworks\\Component\\PasswordStrength\\Blacklist\\BlacklistProviderInterface
        Blacklist chained provider for Password forms.

    Rollerworks\\Component\\PasswordStrength\\Validator\\Constraints\\BlacklistValidator
        Blacklist form validator to be used and instanciated by Symfony ContainerConstraintValidatorFactory.

Importers
^^^^^^^^^

.. glossary::

    RZ\\Roadiz\\CMS\\Importers\\ChainImporter
        :sup:`Factory` Creates an chained importer that will import serialized data based on required entity class.

    RZ\\Roadiz\\CMS\\Importers\\GroupsImporter
        :sup:`Factory` Creates an importer for ``Group``

    RZ\\Roadiz\\CMS\\Importers\\NodesImporter
        :sup:`Factory` Creates an importer for ``Node``

    RZ\\Roadiz\\CMS\\Importers\\NodeTypesImporter
        :sup:`Factory` Creates an importer for ``NodeType``

    RZ\\Roadiz\\CMS\\Importers\\RolesImporter
        :sup:`Factory` Creates an importer for ``Role``

    RZ\\Roadiz\\CMS\\Importers\\SettingsImporter
        :sup:`Factory` Creates an importer for ``Setting``

    RZ\\Roadiz\\CMS\\Importers\\TagsImporter
        :sup:`Factory` Creates an importer for ``Tag``

Logger
^^^^^^

.. glossary::

    logger.handlers
        ``array``

    logger.path
        ``string``

    logger
        ``Monolog\Logger``

Mailer
^^^^^^

.. glossary::

    mailer.transport
        ``\Swift_SmtpTransport`` or ``\Swift_SendmailTransport``

    mailer
        ``\Swift_Mailer``

Routing
^^^^^^^

.. glossary::

    httpKernel
        ``Symfony\Component\HttpKernel\HttpKernel``

    requestStack
        ``Symfony\Component\HttpFoundation\RequestStack``

    requestContext
        ``Symfony\Component\Routing\RequestContext``

    resolver
        ``Symfony\Component\HttpKernel\Controller\ControllerResolver``

    argumentResolver
        ``Symfony\Component\HttpKernel\Controller\ArgumentResolver``

    router
        ``Symfony\Cmf\Component\Routing\ChainRouter``

    staticRouter
        ``RZ\Roadiz\Core\Routing\StaticRouter``

    nodeRouter
        ``RZ\Roadiz\Core\Routing\NodeRouter``

    redirectionRouter
        ``RZ\Roadiz\Core\Routing\RedirectionRouter``

    urlGenerator
        Alias to ``router``

    httpUtils
        ``Symfony\Component\Security\Http\HttpUtils``

    routeListener
        ``RZ\Roadiz\Core\Events\TimedRouteListener``

    routeCollection
        ``RZ\Roadiz\Core\Routing\RoadizRouteCollection``

Security
^^^^^^^^

.. glossary::

    session.pdo
        ``\PDO`` or ``null`` if pdo session are not configured.

    session.storage
        ``Symfony\Component\HttpFoundation\Session\Storage\NativeSessionStorage``

    session
        ``Symfony\Component\HttpFoundation\Session\Session``

    sessionTokenStorage
        ``Symfony\Component\Security\Csrf\TokenStorage\SessionTokenStorage``

    csrfTokenManager
        ``Symfony\Component\Security\Csrf\CsrfTokenManager``

    securityAuthenticationUtils
        ``Symfony\Component\Security\Http\Authentication\AuthenticationUtils``

    contextListener
        ``Symfony\Component\Security\Http\Firewall\ContextListener``

    accessMap
        ``Symfony\Component\Security\Http\AccessMap``

    userProvider
        ``RZ\Roadiz\Core\Handlers\UserProvider``

    userChecker
        ``Symfony\Component\Security\Core\User\UserChecker``

    daoAuthenticationProvider
        ``Symfony\Component\Security\Core\Authentication\Provider\DaoAuthenticationProvider``

    rememberMeAuthenticationProvider
        ``Symfony\Component\Security\Core\Authentication\Provider\RememberMeAuthenticationProvider``

    rememberMeCookieName
        ``string``

    rememberMeCookieLifetime
        ``integer``

    cookieClearingLogoutHandler
        ``Symfony\Component\Security\Http\Logout\CookieClearingLogoutHandler``

    tokenBasedRememberMeServices
        ``Symfony\Component\Security\Http\RememberMe\TokenBasedRememberMeServices``

    rememberMeListener
        ``Symfony\Component\Security\Http\Firewall\RememberMeListener``

    authenticationProviderList
        ``array<Symfony\Component\Security\Core\Authentication\Provider\AuthenticationProviderInterface>``

    authenticationManager
        ``Symfony\Component\Security\Core\Authentication\AuthenticationProviderManager``

    security.voters
        ``array``

    accessDecisionManager
        ``Symfony\Component\Security\Core\Authorization\AccessDecisionManager``

    securityAuthenticationTrustResolver
        ``Symfony\Component\Security\Core\Authentication\AuthenticationTrustResolver``

    securityAuthorizationChecker
        ``Symfony\Component\Security\Core\Authorization\AuthorizationChecker``

    securityTokenStorage
        ``Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorage``

    securityAccessListener
        ``Symfony\Component\Security\Http\Firewall\AccessListener``

    roleHierarchy
        ``RZ\Roadiz\Utils\Security\DoctrineRoleHierarchy``

    roleHierarchyVoter
        ``Symfony\Component\Security\Core\Authorization\Voter\RoleHierarchyVoter``

    groupVoter
        ``RZ\Roadiz\Core\Authorization\Voter\GroupVoter``

    switchUser
        ``Symfony\Component\Security\Http\Firewall\SwitchUserListener``

    firewallMap
        ``Symfony\Component\Security\Http\FirewallMap``

    passwordEncoder
        ``array``

    userImplementations
        ``array``

    userEncoderFactory
        ``Symfony\Component\Security\Core\Encoder\EncoderFactory``

    firewall
        ``RZ\Roadiz\Utils\Security\TimedFirewall``

    accessDeniedHandler
        ``RZ\Roadiz\Core\Authorization\AccessDeniedHandler``

Serialization
^^^^^^^^^^^^^

.. glossary::

    JMS\Serializer\SerializerBuilder
        ``JMS\Serializer\SerializerBuilder``

    serializer.subscribers
        ``array``

    serializer
        ``JMS\Serializer\Serializer``

Solr
^^^^

.. glossary::

    solr
        ``Solarium\Client``

    AdapterInterface
        ``Solarium\Core\Client\Adapter\AdapterInterface``

    SolariumFactoryInterface
        ``RZ\Roadiz\Core\SearchEngine\SolariumFactory``

    solr.ready
        ``boolean`` Return true if Solr server is reachable.

    solr.search.nodeSource
        :sup:`Factory` ``RZ\Roadiz\Core\SearchEngine\NodeSourceSearchHandler``

    solr.search.document
        :sup:`Factory` ``RZ\Roadiz\Core\SearchEngine\DocumentSearchHandler``

Themes
^^^^^^

.. glossary::

    themeResolver
        ``RZ\Roadiz\Utils\Theme\StaticThemeResolver``

    ThemeGenerator
        ``RZ\Roadiz\Utils\Theme\ThemeGenerator``

    logger.themes
        ``Monolog\Logger``

Translation
^^^^^^^^^^^

.. glossary::

    defaultTranslation
        ``RZ\Roadiz\Core\Entities\Translation`` or ``null`` if you don’t have any default translation.

    translator.locale
        ``string`` or ``null``

    translator
        ``Symfony\Component\Translation\Translator``

Twig
^^^^

.. glossary::

    twig.cacheFolder
        ``string``

    twig.loaderFileSystem
        ``Twig\Loader\FilesystemLoader``

    twig.environment_class
        :sup:`Private` ``Twig\Environment``

    twig.formRenderer
        ``Symfony\Bridge\Twig\Form\TwigRendererEngine``

    twig.environment
        ``Twig\Environment``

    twig.extensions
        ``Doctrine\Common\Collections\ArrayCollection``

    twig.filters
        ``Doctrine\Common\Collections\ArrayCollection``

    twig.fragmentHandler
        ``Symfony\Component\HttpKernel\Fragment\FragmentHandler``

    twig.profile
        ``Twig\Profiler\Profile``

    twig.routingExtension
        ``Symfony\Bridge\Twig\Extension\RoutingExtension``

    twig.centralTruncateExtension
        ``Twig\TwigFilter``

    twig.cacheExtension
        ``Asm89\Twig\CacheExtension\Extension``


Configuration
^^^^^^^^^^^^^

.. glossary::

    config.path
        ``string``

    config.handler
        ``RZ\Roadiz\Config\YamlConfigurationHandler``

    config
        ``array``

Workflow
^^^^^^^^

.. glossary::

    workflow.registry
        ``Symfony\Component\Workflow\Registry``

    workflow.node_workflow
        ``RZ\Roadiz\Workflow\NodeWorkflow``


Utils
^^^^^

.. glossary::

    utils.nodeNameChecker
        ``RZ\Roadiz\Utils\Node\NodeNameChecker``

    utils.uniqueNodeGenerator
        ``RZ\Roadiz\Utils\Node\UniqueNodeGenerator``

    utils.universalDataDuplicator
        ``RZ\Roadiz\Utils\Node\UniversalDataDuplicator``
