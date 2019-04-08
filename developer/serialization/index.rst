.. _serialization:

Serialization
=============


.. code-block:: php

    $response = new JsonResponse(
        $this->get('serializer')->serialize(
            $this->nodeSource,
            'json',
            SerializationContext::create()->setGroups(['nodes_sources', 'id'])
        ),
        Response::HTTP_OK,
        [],
        true
    );


Groups
------

.. glossary::

    id
        Serialize every entity ``id``.

    timestamps
        Serialize every date-timed entity ``createdAt`` and ``updatedAt`` fields.

    position
        Serialize every entity ``position`` fields.

    color
        Serialize every entity ``color`` fields.

    nodes_sources
        Serialize entities in a ``NodesSources`` context.

    node
        Serialize entities in a ``Node`` context.

    tag
        Serialize entities in a ``Tag`` context.

    node_type
        Serialize entities in a ``NodeType`` context.

    attribute
        Serialize entities in a ``Attribute`` context.

    custom_form
        Serialize entities in a ``CustomForm`` context.

    document
        Serialize entities in a ``Document`` context.

    folder
        Serialize entities in a ``Folder`` context.

    translation
        Serialize entities in a ``Translation`` context.

    setting
        Serialize entities in a ``Setting`` context.

    setting_group
        Serialize entities in a ``SettingGroup`` context.

