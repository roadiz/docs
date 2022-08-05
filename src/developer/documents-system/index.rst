.. _documents-system-intro:

================
Documents system
================


Exposing documents in API
-------------------------

When using API Platform data transfer objects, Documents are ready-to-use with translations set-up on
``name`` and ``description`` fields. Made sure to configure your API operations with at least ``document_display``
serialization group:

..  code-block:: json

    {
        "@type": "Document",
        "@id": "/api/documents/52",
        "relativePath": "fffb9adc/my_image.jpg",
        "type": "image",
        "mimeType": "image/jpeg",
        "name": null,
        "description": null,
        "embedId": null,
        "embedPlatform": null,
        "imageAverageColor": "#141414",
        "imageWidth": 1000,
        "imageHeight": 750,
        "mediaDuration": 0,
        "copyright": "© John Doe",
        "externalUrl": null,
        "processable": true,
        "thumbnail": null,
        "alt": "This is an image"
    }
