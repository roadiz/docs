.. _exposing_node_types:

Exposing node-types
===================

All resources configuration files are located in ``./config/api_resources`` folder.

Here is an example of API resource for a ``Page`` node-type, you'll find default ``collectionOperations`` and
``itemOperations`` plus a special ``getByPath`` operation which allow overriding **WebResponse** serialization groups.

.. code-block:: yaml

    App\GeneratedEntity\NSPage:
        iri: Page
        shortName: Page
        collectionOperations:
            get:
                method: GET
                normalization_context:
                    groups:
                        - nodes_sources_base
                        - nodes_sources_default
                        - urls
                        - tag_base
                        - translation_base
                        - document_display
        itemOperations:
            get:
                method: GET
                normalization_context:
                    groups:
                        - nodes_sources
                        - urls
                        - tag_base
                        - translation_base
                        - document_display

            getByPath:
                method: GET
                normalization_context:
                    groups:
                        - web_response
                        - position
                        - walker
                        - walker_level
                        - walker_metadata
                        - meta
                        - children
                        - children_count
                        - nodes_sources
                        - urls
                        - tag_base
                        - translation_base
                        - document_display

To automatically generate your resources YAML configuration files, execute the following CLI command:

.. code-block:: shell

    bin/console generate:api-resources