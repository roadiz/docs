.. _web_response:


WebResponse concept
===================

A REST-ful API will expose collection and item entry-points for each resource. But in both case, you need to know your
resource type or your resource identifier **before** executing your API call.
Roadiz introduces a special resource named **WebResponse** which can be called using a ``path`` query param in order
to reduce as much as possible API calls and address `N+1 problem <https://restfulapi.net/rest-api-n-1-problem/>`_.

.. code-block:: http

    GET /api/web_response_by_path?path=/contact

API will expose a WebResponse single item containing:

* An item
* Item breadcrumbs
* Head object
* Item blocks tree-walker
* Item realms
* and if blocks are hidden by Realm configuration

.. code-block:: json

    {
        "@context": "/api/contexts/WebResponse",
        "@id": "/api/web_response_by_path?path=/contact",
        "@type": "WebResponse",
        "item": {
            "@id": "/api/pages/7",
            "@type": "Page",
            "content": "Magni deleniti ut eveniet. Aliquam aut et excepturi vitae placeat molestiae. Molestiae asperiores nihil sed temporibus quibusdam. Non magnam fuga at. sdf",
            "subTitle": null,
            "overTitle": null,
            "headerImage": [],
            "test": null,
            "pictures": [],
            "nodeReferences": [],
            "stickytest": false,
            "sticky": false,
            "customForm": [],
            "title": "Contact",
            "publishedAt": "2021-09-10T15:56:00+02:00",
            "metaTitle": "",
            "metaKeywords": "",
            "metaDescription": "",
            "users": [],
            "node": {
                "@type": "Node",
                "@id": "/api/nodes/7",
                "visible": true,
                "position": 3,
                "tags": []
            },
            "slug": "contact",
            "url": "/contact"
        },
        "breadcrumbs": {
            "@type": "Breadcrumbs",
            "@id": "_:14750",
            "items": []
        },
        "head": {
            "@type": "NodesSourcesHead",
            "@id": "_:14679",
            "googleAnalytics": null,
            "googleTagManager": null,
            "matomoUrl": null,
            "matomoSiteId": null,
            "siteName": "Roadiz dev website",
            "metaTitle": "Contact – Roadiz dev website",
            "metaDescription": "Contact, Roadiz dev website",
            "policyUrl": null,
            "mainColor": null,
            "facebookUrl": null,
            "instagramUrl": null,
            "twitterUrl": null,
            "youtubeUrl": null,
            "linkedinUrl": null,
            "homePageUrl": "/",
            "shareImage": null
        },
        "blocks": [],
        "realms": [],
        "hidingBlocks": false
    }
