.. _services:

Services
========

Roadiz is built upon `Pimple <http://pimple.sensiolabs.org>`_ dependency injection container.
Thanks to this architecture, all Core and Backoffice services are available from any controller
in your themes.

.. code-block:: php

    $this->get('nameOfService');


* Doctrine entity manager: ``$this->get('em')``
* Twig rendering environment: ``$this->get('twig.environment')``
* Translator: ``$this->get('translator')``
* Url matcher: ``$this->get('urlMatcher')``
* Url generator: ``$this->get('urlGenerator')``
* Authorization checker: ``$this->get('securityAuthorizationChecker')``
* User token storage: ``$this->get('securityTokenStorage')``
* Firewall: ``$this->get('firewall')``
* Assets packages: ``$this->get('assetPackages')``
* Email manager: ``$this->get('emailManager')``
* Contact form manager: ``$this->get('contactFormManager')``
* Accessing global settings *ParameterBag*: ``$this->get('settingsBag')``
* Accessing global node-types *ParameterBag*: ``$this->get('nodeTypesBag')``
* Getting an entity handler: ``$this->get('factory.handler')->getHandler($myEntity)``
* …

Entity APIs
-----------

All these services are Doctrine repository wrappers meant to ease querying
entities inside your themes and according to ``AuthorizationChecker``. This will
implicitely check if nodes or node-sources are published when you request them
without bothering to insert the right criteria in your *findBy* calls.

Each of these implements ``AbstractApi`` methods ``getBy`` and ``getOneBy``

* `nodeApi <http://api.roadiz.io/RZ/Roadiz/CMS/Utils/NodeApi.html>`_
* `nodeTypeApi <http://api.roadiz.io/RZ/Roadiz/CMS/Utils/NodeTypeApi.html>`_
* `nodeSourceApi <http://api.roadiz.io/RZ/Roadiz/CMS/Utils/NodeSourceApi.html>`_
* `tagApi <http://api.roadiz.io/RZ/Roadiz/CMS/Utils/TagApi.html>`_

Using Solr API
--------------

Solr is a really powerful tool to search over your node database with
a clever plain-text search engine and the ability to highlight your criteria
in the search results. Before going further, make sure that a Solr server is available
and that it is well configured in your ``config.yml``. You can use the
``bin/roadiz solr:check`` command to verify and then ``bin/roadiz solr:reindex`` command
to force synchronizing your node database with Solr index.

You can use the ``solr.search.nodeSource`` service and its two methods to
get node-sources from a search query.

Simple search results
^^^^^^^^^^^^^^^^^^^^^

``$this->get('solr.search.nodeSource')->search()`` method will return an array of ``NodesSources``

.. code-block:: php

    $criteria = [];
    $results = $this->get('solr.search.nodeSource')
                    ->search(
                        $request->get('q'), # Use ?q query parameter to search with
                        $criteria, # a simple criteria array to filter search results
                        10, # result count
                        true # Search in tags too
                    );

    foreach ($results as $nodeSource) {
        # NodesSources object
        echo $nodeSource->getTitle();
    }

Search results with highlighting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``$this->get('solr.search.nodeSource')->searchWithHighlight()`` method will return an array of array with a simple structure: ``nodeSource`` for the NodesSources object and ``highlighting`` for the *html* data with highlighted text wrapped in ``span.solr-highlight`` html tag.

.. code-block:: php

    $criteria = [];
    $results = $this->get('solr.search.nodeSource')
                    ->searchWithHighlight(
                        $request->get('q'), # Use ?q query parameter to search with
                        $criteria, # a simple criteria array to filter search results
                        10, # result count
                        true # Search in tags too
                    );

    foreach ($results as $result) {
        # NodesSources object
        $nodeSource = $result['nodeSource'];
        # String object (HTML)
        $hightlight = $result['highlighting'];
    }

Search criteria
^^^^^^^^^^^^^^^

Solr will search in *NodesSources* index by default, but it will not filter by translation, type or visibility.
You can add your own search criteria using similar filter names as ``nodeSourceApi``.

- ``visible``: boolean
- ``translation``: a Roadiz Translation object
- ``_locale``: string
- ``tags``: Roadiz Tag object or Tag array
- ``nodeType``: a Roadiz NodeType object
- ``status``: defaults to PUBLISHED

.. code-block:: php

    $criteria = [
        'visible' => true,
        'translation' => $translation,
        'nodeType' => [
            $this->get('nodeTypesBag')->get('Page'),
            // …
        ],
    ];
