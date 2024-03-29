.. _api:

Building headless websites using API
===================================

Since Roadiz v2, headless development is default and is the most powerful way to build reactive websites and
applications. Roadiz is built on `API Platform <https://api-platform.com/>`_, and it exposes all main entities as
API Resources using `DTO (data transfer objects) <https://api-platform.com/docs/core/dto/#using-data-transfer-objects-dtos>`_

.. figure:: ./img/postman.png
    :align: center

    Consuming Roadiz API with Postman application is a great way to explore and test REST calls for your frontend app

.. toctree::
   :maxdepth: 2

   web_response
   exposing_node_types
   serialization

We recommend using `Rezo Zero Nuxt starter <https://github.com/rezozero/nuxt-starter>`_ to build your frontend applications.
This starter is built to use Roadiz API and relies on dynamic routing and supports API redirections.
