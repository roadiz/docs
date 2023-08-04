.. _manual_config:

Manual configuration
====================

Roadiz is a full-stack Symfony application. It follows its configuration scheme as described in
https://symfony.com/doc/5.4/configuration.html

Choose your inheritance model
-----------------------------

*Roadiz* main feature is all about its polymorphic document model which is mapped on a relational database. This requires a
challenging structure which can be lead to some performance bottlenecks when dealing with more than 20-30 node-types.
So we made the data inheritance model configurable to allow switching to `single_table <https://www.doctrine-project.org/projects/doctrine-orm/en/2.7/reference/inheritance-mapping.html#single-table-inheritance>`_ scheme which will be more performant
if you need lots of node-types. However *Single class* model will drop support for fields with the *same name but
not the same type* because all node-type fields will be created in the **same SQL table**.

If you really need to mix field types, we advise you to keep the original `joined table <https://www.doctrine-project.org/projects/doctrine-orm/en/2.7/reference/inheritance-mapping.html#class-table-inheritance>`_ inheritance type which creates a dedicated SQL table for each node-type. *Joined table* inheritance can be very useful
with a small number of node-type (max. 20) and very different fields. But its main drawback is that Roadiz needs to *LEFT JOIN*
every node-type table for each node-source query, **unless you specify one node-type criteria**.

You can configure *Doctrine* strategy for NodesSources inheritance classes in ``config/packages/roadiz_core.yaml``:

.. code-block:: yaml

    # config/packages/roadiz_core.yaml
    roadiz_core:
        inheritance:
            # type: joined
            type: single_table

- Joined class inheritance: ``joined``
- Single table inheritance: ``single_table``

.. warning::

    If you change this setting after creating content in your website, all node-sources data will be lost.

Themes (compatibility with v1.x)
--------------------------------

Themes are statically registered into Roadiz configuration for better performances
and delaying database usage. You have to register any front-end theme in your ``config/packages/roadiz_compat.yaml`` file.
Theme priority is not handled here but in each of your themes by overriding static ``$priority`` value;

.. code-block:: yaml

    # config/packages/roadiz_compat.yaml
    roadiz_compat:
        themes:
            -
                classname: \Themes\DefaultTheme\DefaultThemeApp
                hostname: '*'
                routePrefix: ''
            -
                classname: \Themes\FooBarTheme\FooBarThemeApp
                hostname: 'foobar.test'
                routePrefix: ''

You can define hostname specific themes and add a route-prefix for your routing. Defaults values
are ``'*'`` for the *hostname* and ``''`` (empty string) for the route-prefix.

.. warning::

    No theme configuration will lead into a 404 error on your website home page. But you will still have
    access to the back-office which is now hard-registered into Roadiz configuration.

.. _solr_endpoint:

Solr endpoint
-------------

Roadiz can use an *Apache Solr* search-engine to index nodes-sources.
Add this to your `config/packages/roadiz_core.yaml` to link your CMS to your *Solr* server:

.. code-block:: yaml

    # config/packages/roadiz_core.yaml
    roadiz_core:
        solr:
            endpoint:
                localhost:
                    host: "localhost"
                    port: "8983"
                    path: "/"
                    core: "mycore"
                    timeout: 3
                    username: ""
                    password: ""

Roadiz CLI command can easily handle Solr index. Just type ``./bin/console solr:check`` to get
more information.

Reverse proxy cache invalidation
--------------------------------

Roadiz can request cache invalidation to external and internal cache proxies such as internal
*Symfony* AppCache or a *Varnish* instance. If configured, Roadiz will create a ``BAN`` request
to each configured proxy **when user clears back-office caches**, and it will create a ``PURGE`` request
**on each node-source** *update event* using first reachable node-source URL.

.. code-block:: yaml

    # config/packages/roadiz_core.yaml
    roadiz_core:
        reverseProxyCache:
            frontend:
                default:
                    host: '%env(string:VARNISH_HOST)%'
                    domainName: '%env(string:VARNISH_DOMAIN)%'

.. note::

    Make sure you `configured your external reverse proxy <https://github.com/roadiz/roadiz/blob/develop/samples/varnish_default.vcl>`_
    in order to receive and handle ``BAN`` and ``PURGE`` HTTP requests.

With API Platform you also need to configure ``http_cache`` invalidation section:

.. code-block:: yaml

    # config/packages/api_platform.yaml
    api_platform:
        http_cache:
            invalidation:
                enabled: true
                varnish_urls: ['%env(VARNISH_URL)%']


Cloudflare proxy cache
^^^^^^^^^^^^^^^^^^^^^^

If you are using Cloudflare as a reverse proxy cache, you can configure Roadiz to send requests to Cloudflare
to purge all items or files (when editing a node-source). You need to gather following information:

- Cloudflare zone identifier
- Cloudflare API credentials (Bearer token or email + auth-key)

Then you can configure Roadiz with Bearer token:

.. code-block:: yaml

    # config/packages/roadiz_core.yaml
    roadiz_core:
        reverseProxyCache:
            frontend: []
            cloudflare:
                zone: cloudflare-zone
                bearer: ~

Or with your Email and AuthKey:

.. code-block:: yaml

    # config/packages/roadiz_core.yaml
    roadiz_core:
        reverseProxyCache:
            frontend: []
            cloudflare:
                zone: cloudflare-zone
                email: ~
                key: ~

.. note::

    Roadiz uses *Purge all files* and *Purge Files by URL* entry points: https://api.cloudflare.com/#zone-purge-all-files
    which are available on all Cloudflare plans.

Entities paths
--------------

Roadiz uses *Doctrine* to map object entities to database tables.

.. code-block:: yaml

    # config/packages/doctrine.yaml
    doctrine:
        orm:
            mappings:
                App:
                    is_bundle: false
                    type: attribute
                    dir: '%kernel.project_dir%/src/Entity'
                    prefix: 'App\Entity'
                    alias: App
                RoadizCoreBundle:
                    is_bundle: true
                    type: attribute
                    dir: 'src/Entity'
                    prefix: 'RZ\Roadiz\CoreBundle\Entity'
                    alias: RoadizCoreBundle
                RZ\Roadiz\Core:
                    is_bundle: false
                    type: attribute
                    dir: '%kernel.project_dir%/vendor/roadiz/models/src/Roadiz/Core/AbstractEntities'
                    prefix: 'RZ\Roadiz\Core\AbstractEntities'
                    alias: AbstractEntities
                App\GeneratedEntity:
                    is_bundle: false
                    type: attribute
                    dir: '%kernel.project_dir%/src/GeneratedEntity'
                    prefix: 'App\GeneratedEntity'
                    alias: App\GeneratedEntity
                gedmo_loggable:
                    type: attribute
                    prefix: Gedmo\Loggable\Entity\MappedSuperclass
                    dir: "%kernel.project_dir%/vendor/gedmo/doctrine-extensions/src/Loggable/Entity/MappedSuperclass"
                    alias: GedmoLoggableMappedSuperclass
                    is_bundle: false

Use ``type: attribute`` or ``type: annotation`` according to your Doctrine mapping type.

Configure mailer
----------------

Roadiz uses *Symfony Mailer* to send emails.

https://symfony.com/doc/5.4/mailer.html#transport-setup

.. note::
    Pay attention that many external SMTP services (*Mandrill*, *Mailjet*…) only accept email from validated domains.
    So make sure that your application uses a known ``From:`` email sender not to be blacklisted or blocked
    by these services.
    If you need your emails to be replied to an anonymous address, use ``ReplyTo:`` header instead.

Images processing
-----------------

Roadiz use `Intervention Request Bundle <https://github.com/rezozero/intervention-request-bundle>`_ to automatically
create a lower quality version of your image if they are too big and offer on-the-fly image resizing and optimizing.

.. code-block:: yaml

    # config/packages/rz_intervention_request.yaml
    parameters:
        env(IR_DEFAULT_QUALITY): '90'
        env(IR_MAX_PIXEL_SIZE): '1920'
        ir_default_quality: '%env(int:IR_DEFAULT_QUALITY)%'
        ir_max_pixel_size: '%env(int:IR_MAX_PIXEL_SIZE)%'

    rz_intervention_request:
        driver: 'gd'
        default_quality: '%ir_default_quality%'
        max_pixel_size: '%ir_max_pixel_size%'
        cache_path: "%kernel.project_dir%/public/assets"
        files_path: "%kernel.project_dir%/public/files"
        jpegoptim_path: /usr/bin/jpegoptim
        pngquant_path: /usr/bin/pngquant
        subscribers: []

Additional *Intervention Request* subscribers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Any *Intervention Request* subscriber can be added to configuration with its ``classname``
and its constructor arguments. Here is an example with ``WatermarkListener`` which will
print some text on all your images.

.. code-block:: yaml

    rz_intervention_request:
        # List additional Intervention Request subscribers
        subscribers:
            - class: "AM\\InterventionRequest\\Listener\\WatermarkListener"
              args:
                   - 'Copyright 2017'
                   - 3
                   - 50
                   - "#FF0000"

Use kraken.io to reduce drastically image sizes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since you can add *Intervention Request* subscribers, we created a useful one that sends
every images to `kraken.io <https://kraken.io/>`_ services to shrink them. Once you’ve configured it,
do not forget to empty your caches **and** image caches to see changes.

.. code-block:: yaml

    rz_intervention_request:
        # List additional Intervention Request subscribers
        subscribers:
            - class: "AM\\InterventionRequest\\Listener\\KrakenListener"
              args:
                   - "your-api-key"
                   - "your-api-secret"
                   - true

.. warning::

    Take note that each generated image is sent to *kraken.io* servers. It can generate some overhead
    time on the first time you request an image.

OpenID SSO authentication
-------------------------

Roadiz can use *OpenID* authentication to allow your users to log in with their Google account.

It supports  2 modes:

-  **Requires local user**: Users must have a local account to be able to log in with OpenID.
    This is the default mode.
-  **No local user required**: Users can log in with OpenID without having a local account. A virtual
    account will be created for them with their email address as username and roles listed in ``granted_roles``.
    With this mode, you cannot use Preview mode as it requires a local user.

For both modes, you can restrict users to a specific domain with ``hosted_domain`` parameter.

.. code-block:: yaml

    # config/packages/roadiz_rozier.yaml
    roadiz_rozier:
        open_id:
            # Verify User info in JWT at each login
            verify_user_info: false
            # Standard OpenID autodiscovery URL, required to enable OpenId login in Roadiz CMS.
            discovery_url: '%env(string:OPEN_ID_DISCOVERY_URL)%'
            # For public identity providers (such as Google), restrict users emails by their domain.
            hosted_domain: '%env(string:OPEN_ID_HOSTED_DOMAIN)%'
            # OpenID identity provider OAuth2 client ID
            oauth_client_id: '%env(string:OPEN_ID_CLIENT_ID)%'
            # OpenID identity provider OAuth2 client secret
            oauth_client_secret: '%env(string:OPEN_ID_CLIENT_SECRET)%'
            requires_local_user: false
            granted_roles:
                - ROLE_USER
                - ROLE_BACKEND_USER
                - ROLE_ACCESS_VERSIONS
                - ROLE_ACCESS_DOCTRINE_CACHE_DELETE
                - ROLE_ACCESS_DOCUMENTS
                - ROLE_ACCESS_DOCUMENTS_LIMITATIONS
                - ROLE_ACCESS_DOCUMENTS_DELETE
                - ROLE_ACCESS_DOCUMENTS_CREATION_DATE
                - ROLE_ACCESS_NODES
                - ROLE_ACCESS_NODES_DELETE
                - ROLE_ACCESS_NODES_SETTING
                - ROLE_ACCESS_NODES_STATUS
                - ROLE_ACCESS_REDIRECTIONS
                - ROLE_ACCESS_TAGS
                - ROLE_ACCESS_TAGS_DELETE
                - ROLE_ACCESS_CUSTOMFORMS
                - ROLE_ACCESS_CUSTOMFORMS_DELETE
                - ROLE_ACCESS_CUSTOMFORMS_RETENTION
                - ROLE_ACCESS_ATTRIBUTES
                - ROLE_ACCESS_ATTRIBUTES_DELETE
                - ROLE_ACCESS_NODE_ATTRIBUTES
                - ROLE_ACCESS_SETTINGS
                - ROLE_ACCESS_LOGS
                - ROLE_ACCESS_USERS
                - ROLE_ACCESS_USERS_DELETE
                - ROLE_ACCESS_GROUPS
                - ROLE_ACCESS_TRANSLATIONS


Console commands
----------------

Roadiz can be executed as a simple CLI tool using your SSH connection. This is useful to
handle basic administration tasks with no need of backoffice administration.

.. code-block:: console

    ./bin/console

If your system is not configured to have *php* located in ``/usr/bin/php`` use it this way:

.. code-block:: console

    php ./bin/console

Default command with no arguments will show you the available commands list. Each command has its
own parameters. You can use the argument ``--help`` to get more information about each tool:

.. code-block:: console

    ./bin/console install --help


We even made *Doctrine* CLI tools directly available from Roadiz Console. Be careful, these are powerful
commands which can alter your database and make you lose precious data. Especially when you will need to update
your database schema after a Theme or a Core update. **Always make a database back-up before any Doctrine operation**.

