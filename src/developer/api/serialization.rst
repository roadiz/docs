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

    node_children
        Serialize Nodes with their ``children``.

    node_attributes
        Serialize Nodes with their ``attribute values``.

    tag
        Serialize Tag.

    tag_base
        Serialize Tags with minimum information.

    tag_parent
        Serialize Tags with their ``parent``.

    tag_children
        Serialize Tags with their ``children``, do not use with ``tag_parent`` group.

    node_type
        Serialize entities in a ``NodeType`` context.

    attribute
        Serialize entities in a ``Attribute`` context.

    attribute_documents
        Serialize documents linked to a ``Attribute`` for each virtual field.

    custom_form
        Serialize entities in a ``CustomForm`` context.

    document
        Serialize entities in a ``Document`` context.

    document_display
        Serialize ``Document`` information required for displaying them.

    document_private
        Serialize ``Document`` privacy information

    document_display_sources
        Serialize ``Document`` information required for displaying alternative sources (audio, video).

    document_folders
        Serialize ``Document`` information required for displaying attached folders.

    folder
        Serialize entities in a ``Folder`` context.

    translation
        Serialize entities in a ``Translation`` context.

    translation_base
        Serialize ``Translation`` information required for displaying them.

    setting
        Serialize entities in a ``Setting`` context.

    setting_group
        Serialize entities in a ``SettingGroup`` context.

    user
        Serialize entities in a ``User`` context.

    user_group
        Serialize User entity with its groups.

    user_role
        Serialize User entity with its roles.

    user_personal
        Serialize User entity with its personal information.

    user_identifier
        Serialize User entity with its identifier (may be a personal information).

