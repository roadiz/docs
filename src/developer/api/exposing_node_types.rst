.. _exposing_node_types:

Exposing node-types
===================

All resources configuration files are located in ``./config/api_resources`` folder.

Here is an example of API resource for a ``Page`` node-type, you'll find default ``operations``plus a special ``getByPath`` operation which allow overriding **WebResponse** serialization groups.

.. code-block:: yaml

    App\GeneratedEntity\NSPage:
        types:
            - Page
        operations:
            ApiPlatform\Metadata\GetCollection:
                method: GET
                shortName: Page
                normalizationContext:
                    enable_max_depth: true
                    groups:
                        - nodes_sources_base
                        - nodes_sources_default
                        - urls
                        - tag_base
                        - translation_base
                        - document_display
                        - document_thumbnails
                        - document_display_sources
                        - nodes_sources_images
                        - nodes_sources_boolean
            _api_page_archives:
                method: GET
                class: ApiPlatform\Metadata\GetCollection
                shortName: Page
                uriTemplate: /pages/archives
                extraProperties:
                    archive_enabled: true
                openapiContext:
                    summary: 'Retrieve all Page ressources archives months and years'
            ApiPlatform\Metadata\Get:
                method: GET
                shortName: Page
                normalizationContext:
                    groups:
                        - nodes_sources
                        - urls
                        - tag_base
                        - translation_base
                        - document_display
                        - document_thumbnails
                        - document_display_sources
                        - nodes_sources_images
                        - nodes_sources_boolean
            getByPath:
                method: GET
                class: ApiPlatform\Metadata\Get
                uriTemplate: /web_response_by_path
                read: false
                controller: RZ\Roadiz\CoreBundle\Api\Controller\GetWebResponseByPathController
                normalizationContext:
                    pagination_enabled: false
                    enable_max_depth: true
                    groups:
                        - nodes_sources
                        - urls
                        - tag_base
                        - translation_base
                        - document_display
                        - document_thumbnails
                        - document_display_sources
                        - nodes_sources_images
                        - nodes_sources_boolean
                        - web_response
                        - walker
                        - walker_level
                        - walker_metadata
                        - meta
                        - children
                openapiContext:
                    tags:
                        - WebResponse
                    summary: 'Get a resource by its path wrapped in a WebResponse object'
                    description: 'Get a resource by its path wrapped in a WebResponse'
                    parameters:
                        - { type: string, name: path, in: query, required: true, description: 'Resource path, or `/` for home page', schema: { type: string } }


To automatically generate your resources YAML configuration files, execute the following CLI command:

.. code-block:: shell

    bin/console generate:api-resources
