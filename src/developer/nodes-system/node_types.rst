.. _managing_node_types:

Managing node-types
===================

First and foremost, you need to create a new node-type before creating any kind of node.

If you want to know more about what a node-type is, please visit the other section of the developer documentation.


Add node-type
-------------

You need to create a new file in ``config/node_types/`` with name the name of your node type in lower case (``nodetypename.yaml``).

this file need to respect the structure of an nodeType and the type of the parameters :

.. code-block:: YAML

    # name is a string type, is required
    name: nodeTypeName
    # displayName is a string type, is required
    displayName: node type name
    # color is a string type, is optionnal
    color: '#000000'
    # description is a string type, is optionnal
    description: nodeTypeName description
    # visible is a boolean type, is optionnal
    visible: true
    # publishable is a boolean type, is optionnal
    publishable: false
    # attributable is a boolean type, is optionnal
    attributable: true
    # sortingAttributesByWeight is a boolean type, is optionnal
    sortingAttributesByWeight: false
    # reachable is a boolean type, is optionnal
    reachable: true
    # hidingNodes is a boolean type, is optionnal
    hidingNodes: false
    # hidingNonReachableNodes is a boolean type, is optionnal
    hidingNonReachableNodes: true
    # for the nodeTypeField read the section Adding node-type field.
    fields :
        - ...
        - ...
    # defaultTtl is a integer type, is optionnal
    defaultTtl: 15
    # searchable is a boolean type, is optionnal
    searchable: true


⚠️ You can use ``nodetypes:validate-files`` for check if the structure of your file is correct.

If your files was correct you can run ``app:migrate`` command and check :

#. If your ``src/GeneratedEntity/NSnodeTypeName.php`` was correctly generate.
#. If your ``config/api_ressources/nsnodetypename.yml`` was correctly generate (you can test it with api: ``{{url}}/api/docs``).

Delete node-type
----------------

You need to remove the file associate with the node type you want to remove into ``config/node_types/``, ``src/GeneratedEntity/`` and ``config/api_resources/``

⚠️ When you delete a node type, it does not delete the nodes that are linked to that type in the database.
You need to create a migration (command: ``bin/console doctrine:migrations:generate``) with one of the two solutions.

* ‼️Soft delete, if you want to change into another existing node type, you can keep data of node and children:

.. code-block:: PHP

    public function up(Schema $schema): void
    {
        $this->addSql('UPDATE nodes SET nodetype_name = AnotherNodeTypeName WHERE nodetype_name = NodeTypeName');
        $this->addSql('UPDATE nodes_sources SET discr = AnotherNodeTypeName WHERE discr = NodeTypeName');
    }

    public function down(Schema $schema): void
    {
    }

💡If you want to keep your data without transferring it into another nodetype you can juste create an nodeType named ghostNodeType who was not visible and without field,
And you can tranfer your nodes to this nodeType

* ‼️Hard delete, if you want to delete all data of nodes an children nodes associate with that nodeType:

.. code-block:: PHP

    public function up(Schema $schema): void
    {
        $this->addSql('DELETE nodes WHERE nodetype_name = NodeTypeName');
        $this->addSql('DELETE nodes_sources WHERE discr = NodeTypeName');
    }

    public function down(Schema $schema): void
    {
    }


Adding node-type field
----------------------

Into the `yaml` node type file the parameters fields is an array of each field you want to add.

Exemple :

.. code-block:: YAML

    fields :
        -
            # exemple field with minimal requirement
            name: field_name_1
            label: field Name
            type: string
        -
            # exemple with all parameters a field can have
            name: field_name_2
            label: Field Name Two
            type: markdown
            groupName: string
            placeholder: string
            description: string
            minLength: 0
            maxLength: 50
            serializationMaxDepth: 2
            universal: false
            excludeFromSearch: false
            excludedFromSerialization: false
            indexed: false
            visible: true
            expanded: false
            defaultValues: null # depend on type
            normalizationContext:
                groups:
                    - get
                    - nodes_sources_base
                    - nodes_sources_default
            serializationGroups: null
            serializationExclusionExpression: null

For have more information of type of field see :ref:`nodes-type-fields`

⚠️ You can use ``nodetypes:validate-files`` for check if the structure of your file is correct.

If your files was correct you can run ``app:migrate`` command.

This command update your node source entity and generate migration for add your fields in node_sources if it does'nt already exist in another node type.

Removing node-type field
------------------------

To remove a field of a node type you need to go to the config file of you node type into ``config/node_types/``.

And remove the field you want to delete into fields array (example you want to remove field_name_2) :

BEFORE :

.. code-block:: YAML

    fields :
        -
            name: field_name_1
            label: field Name
            type: string
        -
            name: field_name_2
            label: Field Name Two
            type: markdown

AFTER :

.. code-block:: YAML

    fields :
        -
            name: field_name_1
            label: field Name
            type: string

⚠️ You can use ``nodetypes:validate-files`` for check if the structure of your file is correct.

If your files was correct you can run ``app:migrate`` command.

This command update your node source entity and generate migration for drop your field in node_sources if it does'nt already exist in another node type.