.. _events:

Events
======

Roadiz node system implements several events. So you will be able to create
and inject your own event subscribers inside *Roadiz* dispatcher.

To understand how the event dispatcher works, you should read the
`documentation from Symfony <http://symfony.com/doc/current/components/event_dispatcher/introduction.html>`_ before.


Nodes events
------------

``RZ\Roadiz\Core\Events\NodeEvents``

* *node.created:* ``NodeEvents::NODE_CREATED``
* *node.updated:* ``NodeEvents::NODE_UPDATED``
* *node.deleted:* ``NodeEvents::NODE_DELETED``
* *node.undeleted:* ``NodeEvents::NODE_UNDELETED``
* *node.tagged:* ``NodeEvents::NODE_TAGGED`` This event is triggered for tag and un-tag action.
* *node.visibilityChanged:* ``NodeEvents::NODE_VISIBILITY_CHANGED`` This event is triggered each time a node becomes visible or unvisible.
* *node.statusChanged:* ``NodeEvents::NODE_STATUS_CHANGED`` This event is triggered each time a node status changes.

Every node events methods will accept a ``RZ\Roadiz\Core\Events\FilterNodeEvent`` object as argument.
This object contains the current ``Node`` entity. You will get it using ``$event->getNode()``.

NodesSources events
-------------------

``RZ\Roadiz\Core\Events\NodesSourcesEvents``

* *nodeSource.created:* ``NodesSourcesEvents::NODE_SOURCE_CREATED``
* *nodeSource.updated:* ``NodesSourcesEvents::NODE_SOURCE_UPDATED``
* *nodeSource.deleted:* ``NodesSourcesEvents::NODE_SOURCE_DELETED``

Every node-source events methods will accept a ``RZ\Roadiz\Core\Events\FilterNodesSourcesEvent`` object as argument.
This object contains the current ``NodesSources`` entity. You will get it using ``$event->getNodeSource()``.

.. note::
    You will find a simple subscriber example in Roadiz back-office theme which is called ``Themes\Rozier\Events\SolariumSubscriber``.
    This subscriber is useful to update or delete your *Solr* index documents against your node-source database.

Tags events
-----------

``RZ\Roadiz\Core\Events\TagEvents``

* *tag.created:* ``TagEvents::TAG_CREATED``
* *tag.updated:* ``TagEvents::TAG_UPDATED``
* *tag.deleted:* ``TagEvents::TAG_DELETED``

Every tag events methods will accept a ``RZ\Roadiz\Core\Events\FilterTagEvent`` object as argument.
This object contains the current ``Tag`` entity. You will get it using ``$event->getTag()``.

Translations events
-------------------

``RZ\Roadiz\Core\Events\TranslationEvents``

* *translation.created:* ``TranslationEvents::TRANSLATION_CREATED``
* *translation.updated:* ``TranslationEvents::TRANSLATION_UPDATED``
* *translation.deleted:* ``TranslationEvents::TRANSLATION_DELETED``

Every tag events methods will accept a ``RZ\Roadiz\Core\Events\FilterTranslationEvent`` object as argument.
This object contains the current ``Translation`` entity. You will get it using ``$event->getTranslation()``.

UrlAlias events
-------------------

``RZ\Roadiz\Core\Events\UrlAliasEvents``

* *urlAlias.created:* ``UrlAliasEvents::URL_ALIAS_CREATED``
* *urlAlias.updated:* ``UrlAliasEvents::URL_ALIAS_UPDATED``
* *urlAlias.deleted:* ``UrlAliasEvents::URL_ALIAS_UPDATED``

Every tag events methods will accept a ``RZ\Roadiz\Core\Events\FilterUrlAliasEvent`` object as argument.
This object contains the current ``UrlAlias`` entity. You will get it using ``$event->getUrlAlias()``.
