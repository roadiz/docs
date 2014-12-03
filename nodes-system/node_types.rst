.. _node-types:

==========
Node-types
==========

What is a Node-type
-------------------

A node-type is the blueprint of your node-source. It will contain all the fields that we will use to generate a extended node-source class.

For example, a node-type "Page" will contain the field "content" and "header image". The "title" field is always a content of node-source class.
It's node-type generate a class named "NSPage" which extend the node-source class. We can find it in the ``gen-src/GeneratedNodeSources``.
Dont modify the generate class! You need to modify it by the backend interface.

Let's see a little schema of what data field avec the generated class with the example node-type:

.. image:: ./NSPage-schema.svg
   :align: center

The translation is not a field. It's write on the schema because it's a important thing which comming by node-type.

Now let's have a look on node-source.
