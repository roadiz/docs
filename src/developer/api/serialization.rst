.. _serialization:

Serialization groups
--------------------

*Roadiz* CMS uses ``symfony/serializer`` to perform JSON serialization over any objects, especially *Doctrine* entities.


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
        Serialize entities in a ``NodesSources`` context (all fields).

    nodes_sources_base
        Serialize entities in a ``NodesSources`` context, but with essential information.

    nodes_sources_documents
        Serialize documents linked to a ``NodesSources`` for each virtual field.

    nodes_sources_default
        Serialize ``NodesSources`` fields not contained in any **group**.

    nodes_sources_``group``
        Custom serialization groups are created according to your node-typ fields groups.
        For example, if you set a field to a ``link`` group, ``nodes_sources_link`` serialization
        group will be automatically generated for this field. *Be careful*, Roadiz will use groups
        *canonical names* to generate serialization groups, it can mix ``_`` and ``-``.

    node
        Serialize entities in a ``Node`` context.

    tag
        Serialize entities in a ``Tag`` context.

    tag_base
        Serialize entities in a ``Tag`` context.

    node_type
        Serialize entities in a ``NodeType`` context.

    attribute
        Serialize entities in a ``Attribute`` context.

    custom_form
        Serialize entities in a ``CustomForm`` context.

    document
        Serialize entities in a ``Document`` context.

    document_display
        Serialize ``Document`` information required for displaying them.

    document_display_sources
        Serialize ``Document`` information required for displaying alternative sources (audio, video).

    document_folders
        Serialize ``Document`` information required for displaying attached folders.

    folder
        Serialize entities in a ``Folder`` context.

    translation
        Serialize entities in a ``Translation`` context.

    setting
        Serialize entities in a ``Setting`` context.

    setting_group
        Serialize entities in a ``SettingGroup`` context.

