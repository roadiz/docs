.. _events:

Events
======

Roadiz node system implements several events. So you will be able to create
and inject your own event subscribers inside *Roadiz* dispatcher.

To understand how the event dispatcher works, you should read the
`Symfony documentation at <http://symfony.com/doc/current/components/event_dispatcher/introduction.html>`_ before.


Nodes events
------------

* ``RZ\Roadiz\Core\Events\Node\NodeCreatedEvent::class``
* ``RZ\Roadiz\Core\Events\Node\NodeUpdatedEvent::class``
* ``RZ\Roadiz\Core\Events\Node\NodeDeletedEvent::class``
* ``RZ\Roadiz\Core\Events\Node\NodeUndeletedEvent::class``
* ``RZ\Roadiz\Core\Events\Node\NodeDuplicatedEvent::class``
* ``RZ\Roadiz\Core\Events\Node\NodePathChangedEvent::class``
* ``RZ\Roadiz\Core\Events\Node\NodeTaggedEvent::class``: This event is triggered for tag and un-tag action.
* ``RZ\Roadiz\Core\Events\Node\NodeVisibilityChangedEvent::class``: This event is triggered each time a node becomes visible or unvisible.
* ``RZ\Roadiz\Core\Events\Node\NodeStatusChangedEvent::class``: This event is triggered each time a node status changes.

Each node event object contains the current ``Node`` entity. You will get it using ``$event->getNode()``.

NodesSources events
-------------------

``RZ\Roadiz\Core\Events\NodesSourcesEvents``

* ``RZ\Roadiz\Core\Events\NodesSources\NodesSourcesCreatedEvent::class``
* ``RZ\Roadiz\Core\Events\NodesSources\NodesSourcesPreUpdatedEvent::class``: This event is dispatched BEFORE entity manager FLUSHED.
* ``RZ\Roadiz\Core\Events\NodesSources\NodesSourcesUpdatedEvent::class``: This event is dispatched AFTER entity manager FLUSHED.
* ``RZ\Roadiz\Core\Events\NodesSources\NodesSourcesDeletedEvent::class``

Each node-source event object contains the current ``NodesSources`` entity. You will get it using ``$event->getNodeSource()``.

* ``RZ\Roadiz\Core\Events\NodesSources\NodesSourcesIndexingEvent::class``: This event type is dispatched during Solr indexation. Your event will be ``\RZ\Roadiz\Core\Events\FilterSolariumNodeSourceEvent`` and it will allow you to alter or improve your Solr index according to your node-source type.

.. note::
    You will find a simple subscriber example in Roadiz back-office theme which is called ``Themes\Rozier\Events\SolariumSubscriber``.
    This subscriber is useful to update or delete your *Solr* index documents against your node-source database.

* ``RZ\Roadiz\Core\Events\NodesSources\NodesSourcesPathGeneratingEvent::class``: This event type is dispatched when the node-router generate a path for your node-source using ``{{ path() }}`` Twig method or ``$this->get('urlGenerator')->generate()`` controller method. The default subscriber will generate the complete hierarchical path for any node-source using their identifier (available url-alias or node’ name).

Tags events
-----------

* ``RZ\Roadiz\Core\Events\Tag\TagCreatedEvent::class``
* ``RZ\Roadiz\Core\Events\Tag\TagUpdatedEvent::class``
* ``RZ\Roadiz\Core\Events\Tag\TagDeletedEvent::class``

Each tag event object contains the current ``Tag`` entity. You will get it using ``$event->getTag()``.

Folders events
--------------

* ``RZ\Roadiz\Core\Events\Folder\FolderCreatedEvent::class``
* ``RZ\Roadiz\Core\Events\Folder\FolderUpdatedEvent::class``
* ``RZ\Roadiz\Core\Events\Folder\FolderDeletedEvent::class``

Each folder event object contains the current ``Folder`` entity. You will get it using ``$event->getFolder()``.

Translations events
-------------------

* ``RZ\Roadiz\Core\Events\Translation\TranslationCreatedEvent::class``
* ``RZ\Roadiz\Core\Events\Translation\TranslationUpdatedEvent::class``
* ``RZ\Roadiz\Core\Events\Translation\TranslationDeletedEvent::class``

Each folder event object contains the current ``Translation`` entity. You will get it using ``$event->getTranslation()``.

UrlAlias events
---------------

* ``RZ\Roadiz\Core\Events\UrlAlias\UrlAliasCreatedEvent::class``
* ``RZ\Roadiz\Core\Events\UrlAlias\UrlAliasUpdatedEvent::class``
* ``RZ\Roadiz\Core\Events\UrlAlias\UrlAliasDeletedEvent::class``

Each folder event object contains the current ``UrlAlias`` entity. You will get it using ``$event->getUrlAlias()``.

User events
-----------

* ``RZ\Roadiz\Core\Events\User\UserCreatedEvent::class``
* ``RZ\Roadiz\Core\Events\User\UserUpdatedEvent::class``
* ``RZ\Roadiz\Core\Events\User\UserDeletedEvent::class``
* ``RZ\Roadiz\Core\Events\User\UserDisabledEvent::class``
* ``RZ\Roadiz\Core\Events\User\UserEnabledEvent::class``
* ``RZ\Roadiz\Core\Events\User\UserPasswordChangedEvent::class``

Each folder event object contains the current ``User`` entity. You will get it using ``$event->getUser()``.