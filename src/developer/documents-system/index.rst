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
        "@id": "/api/documents/xxxxx",
        "relativePath": "xxxxxxx/my_image.jpg",
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

Expose document thumbnails
--------------------------

Thumbnails are exposed by default for each document, it is useful when documents are not displayable: PDF, native video, ZIP, etc:

..  code-block:: json

    {
        "@type": "Document",
        "@id": "/api/documents/xxxxx",
        "relativePath": "xxxxxxx/img_2004_framed_1080p_2000.webm",
        "type": "video",
        "mimeType": "video/webm",
        "name": null,
        "description": null,
        "embedId": null,
        "embedPlatform": null,
        "imageAverageColor": null,
        "imageWidth": 1920,
        "imageHeight": 1080,
        "mediaDuration": 14,
        "copyright": null,
        "externalUrl": null,
        "processable": false,
        "thumbnail": {
            "@type": "Document",
            "@id": "/api/documents/xxxxx",
            "relativePath": "xxxxxxx/img_2004_framed_1080p_2000.png",
            "type": "image",
            "mimeType": "image/png",
            "name": null,
            "description": null,
            "embedId": null,
            "embedPlatform": null,
            "imageAverageColor": "#917357",
            "imageWidth": 2662,
            "imageHeight": 1504,
            "mediaDuration": 0,
            "copyright": null,
            "externalUrl": null,
            "processable": true,
            "thumbnail": null,
            "alt": "img_2004_framed_1080p_2000.png"
        },
        "alt": "img_2004_framed_1080p_2000.webm"
    }


Expose document alternative sources
-----------------------------------

Alternative sources are not serialized by default for performance matters, but you can enable them in your project.
Add ``document_display_sources`` serialization group to your resource configuration.

..  code-block:: json

    {
        "@type": "Document",
        "@id": "/api/documents/xxxxx",
        "relativePath": "xxxxxxxx/img_2004_framed_1080p_2000.webm",
        "type": "video",
        "mimeType": "video/webm",
        "name": null,
        "description": null,
        "embedId": null,
        "embedPlatform": null,
        "imageAverageColor": null,
        "imageWidth": 1920,
        "imageHeight": 1080,
        "mediaDuration": 14,
        "copyright": null,
        "externalUrl": null,
        "processable": false,
        "thumbnail": {
            "@type": "Document",
            "@id": "/api/documents/xxxxx",
            "relativePath": "xxxxxxxx/img_2004_framed_1080p_2000.png",
            "type": "image",
            "mimeType": "image/png",
            "name": null,
            "description": null,
            "embedId": null,
            "embedPlatform": null,
            "imageAverageColor": "#917357",
            "imageWidth": 2662,
            "imageHeight": 1504,
            "mediaDuration": 0,
            "copyright": null,
            "externalUrl": null,
            "processable": true,
            "thumbnail": null,
            "alt": "img_2004_framed_1080p_2000.png"
        },
        "altSources": [
            {
                "@type": "Document",
                "@id": "/api/documents/xxxxx",
                "relativePath": "xxxxxxxx/img_2004_framed_1080p_2000.mp4",
                "type": "video",
                "mimeType": "video/mp4",
                "name": null,
                "description": null,
                "embedId": null,
                "embedPlatform": null,
                "imageAverageColor": null,
                "imageWidth": 0,
                "imageHeight": 0,
                "mediaDuration": 0,
                "copyright": null,
                "externalUrl": null,
                "processable": false,
                "thumbnail": null,
                "alt": "img_2004_framed_1080p_2000.mp4"
            }
        ],
        "alt": "img_2004_framed_1080p_2000.webm"
    }

Expose document folders
-----------------------

Document folders are not serialized by default for performance matters, but you can enable them in your project.
Add ``document_folders`` serialization group to your resource configuration.

..  code-block:: json

    {
        "@type": "Document",
        "@id": "/api/documents/3436",
        "relativePath": "xxxxxxxx/youtube_wplj0yxcnwk.jpg",
        "type": "image",
        "mimeType": "image/jpeg",
        "name": "Shirine - Bande annonce",
        "description": "",
        "embedId": "wPlj0YxCNwk",
        "embedPlatform": "youtube",
        "imageAverageColor": "#2d2426",
        "imageWidth": 200,
        "imageHeight": 113,
        "mediaDuration": 0,
        "copyright": "Opéra de Lyon (https://www.youtube.com/user/OperadeLyon)",
        "externalUrl": null,
        "processable": true,
        "thumbnail": null,
        "folders": [
            {
                "@type": "Folder",
                "@id": "/api/folders/20",
                "slug": "danse",
                "name": "Danse",
                "visible": true
            },
            {
                "@type": "Folder",
                "@id": "/api/folders/31",
                "slug": "opera-inside",
                "name": "Opera-inside",
                "visible": false
            }
        ],
        "alt": "Shirine - Bande annonce"
    }
