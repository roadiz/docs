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
    config
        ``array``

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
        ``Doctrine\ORM\EntityManager``
    em.eventSubscribers
        ``array``
    nodesSourcesUrlCacheProvider
        ``Doctrine\Common\Cache\CacheProvider``

Embed documents
^^^^^^^^^^^^^^^

.. glossary::

    document.platforms
        ``array``
    embed_finder.youtube
        ``RZ\Roadiz\Utils\MediaFinders\YoutubeEmbedFinder``
    embed_finder.vimeo
        ``RZ\Roadiz\Utils\MediaFinders\VimeoEmbedFinder``
    embed_finder.dailymotion
        ``RZ\Roadiz\Utils\MediaFinders\DailymotionEmbedFinder``
    embed_finder.soundcloud
        ``RZ\Roadiz\Utils\MediaFinders\SoundcloudEmbedFinder``

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
        ``RZ\Roadiz\Utils\EmailManager``
    contactFormManager
        ``RZ\Roadiz\Utils\ContactFormManager``
    factory.handler
        ``RZ\Roadiz\Core\Handlers\HandlerFactory``
        Creates any Handler based on entity class.
    node.handler
        ``RZ\Roadiz\Core\Handlers\NodeHandler``
    nodes_sources.handler
        ``RZ\Roadiz\Core\Handlers\NodesSourcesHandler``
    node_type.handler
        ``RZ\Roadiz\Core\Handlers\NodeTypeHandler``
    node_type_field.handler
        ``RZ\Roadiz\Core\Handlers\NodeTypeFieldHandler``
    document.handler
        ``RZ\Roadiz\Core\Handlers\DocumentHandler``
    custom_form.handler
        ``RZ\Roadiz\Core\Handlers\CustomFormHandler``
    custom_form_field.handler
        ``RZ\Roadiz\Core\Handlers\CustomFormFieldHandler``
    folder.handler
        ``RZ\Roadiz\Core\Handlers\FolderHandler``
    font.handler
        ``RZ\Roadiz\Core\Handlers\FontHandler``
    group.handler
        ``RZ\Roadiz\Core\Handlers\GroupHandler``
    newsletter.handler
        ``RZ\Roadiz\Core\Handlers\NewsletterHandler``
    tag.handler
        ``RZ\Roadiz\Core\Handlers\TagHandler``
    translation.handler
        ``RZ\Roadiz\Core\Handlers\TranslationHandler``
    document.viewer
        ``RZ\Roadiz\Core\Viewers\DocumentViewer``
    translation.viewer
        ``RZ\Roadiz\Core\Viewers\TranslationViewer``
    user.viewer
        ``RZ\Roadiz\Core\Viewers\UserViewer``
    document.url_generator
        ``RZ\Roadiz\Utils\UrlGenerators\DocumentUrlGenerator``
    document.factory
        ``RZ\Roadiz\Utils\Document\DocumentFactory``

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
