.. _services:

Using Roadiz services
=====================

Roadiz is built upon `Pimple <http://pimple.sensiolabs.org>`_ dependency injection container.
Thanks to this architecture, all Core and Backoffice services are available from any controller
in your themes.

.. code-block:: php

    $this->getService('nameOfService');


* Doctrine entity manager: ``$this->getService('em')``
* Twig rendering environment: ``$this->getService('twig.environment')``
* Translator: ``$this->getService('translator')``
* Url matcher: ``$this->getService('urlMatcher')``
* Url generator: ``$this->getService('urlGenerator')``
* Security context: ``$this->getService('securityContext')``
* Firewall: ``$this->getService('firewall')``
* …


Entity APIs
-----------

All these services are Doctrine repository wrappers meant to ease querying
entities inside your themes and according to SecurityContext.

Each of these implements ``AbstractApi`` methods ``getBy`` and ``getOneBy``

* `nodeApi <http://api.roadiz.io/RZ/Roadiz/CMS/Utils/NodeApi.html>`_
* `nodeTypeApi <http://api.roadiz.io/RZ/Roadiz/CMS/Utils/NodeTypeApi.html>`_
* `nodeSourceApi <http://api.roadiz.io/RZ/Roadiz/CMS/Utils/NodeSourceApi.html>`_
* `tagApi <http://api.roadiz.io/RZ/Roadiz/CMS/Utils/TagApi.html>`_