.. _nodes-system-intro:

===================================
Node-types, nodes-sources and nodes
===================================

This part is the most important part of Roadiz. Quite everything in your website will be a node.

Let's check this simple node schema before explain it.

.. image:: ./img/node-struct.*

Now, it's time to explain how it's working!

.. _node-types:

What is a Node-type
-------------------

A node-type is the blueprint for your node-source.
It will contain all fields that Roadiz will use to generate an extended node-source class.

.. image:: ./img/NSPage-php.*
   :align: center


For example, a node-type "Page" will contain "content" and "header image" fields.
The "title" field is always available as it is hard-coded in ``NodesSources`` class.
After saving your node-type, Roadiz generates a ``NSPage`` class which extends the ``NodesSources`` class.
You will find it in the ``gen-src/GeneratedNodeSources`` (or ``app/gen-src/GeneratedNodeSources`` with *Roadiz Standard edition*).
Then Roadiz calls *Doctrine* update tool to migrate your database schema.
**Do not modify the generated class.** You’ll have to update it by the backend interface.

Here is a schema to understand how node-types can define custom fields into node-sources:

.. image:: ./img/NSPage-schema.*
   :align: center


Most of node-types management will be done in your backoffice interface. You will be able to
create, update node-types objects and each of their node-type fields independently. But if you prefer,
you can use CLI commands to create types and fields. With Roadiz CLI commands you get several tools to manage node-types.
We really encourage you to check the commands with ``--help`` argument, as following:

.. code-block:: console

    bin/roadiz nodetypes:add-fields
    bin/roadiz nodetypes:create
    bin/roadiz nodetypes:delete
    bin/roadiz nodetypes:list

Keep in mind that each node-type or node-type fields operation require a database update as Doctrine have to create
a specific table per node-type. Do not forget to execute ``bin/roadiz orm:schema-tool:update`` tools to perform
updates. It’s very important to understand that *Doctrine* needs to see your node-types generated classes **before**
upgrading database schema. If they don’t exist, it won’t able to create your custom types tables, or worst, it could
delete existing data since *Doctrine* won’t recognize specific tables.

Now let's have a look on node-sources.


.. _node-sources-intro:

Node-sources and translations
-----------------------------

Once your node-type created, its definition is stored in database in ``node_types`` and ``node_type_fields`` tables.
This informations will be only used to build your node-sources edition forms in backoffice and to build a custom database table.

Inheritance mapping
^^^^^^^^^^^^^^^^^^^

With Roadiz, each node-types data (called node-sources) is stored in a different table prefixed with ``ns_``. When you create a *Page*
node-type with 2 fields (*content* and *excerpt*), Roadiz tells Doctrine to build a ``ns_page`` table with 2 columns and one primary key column inherited from ``nodes_sources`` table. It’s called *inheritance mapping*: your ``ns_page`` table extends ``nodes_sources`` table and when you are querying a *Page* from database, Doctrine mix the data coming from these 2 tables to create a complete node-source.

At the end your node-source *Page* won’t contain only 2 fields but many more as ``NodesSources`` entity offers ``title``, ``metaTitle``,
``metaDescription``, ``metaKeywords`` and others useful data-fields which can be used among all node-types.

Translations
^^^^^^^^^^^^

Node-sources inheritance mapping is not only used to customize data but to make data translations available. As you saw in the first picture, each nodes can handle many node-sources, one per translation.

