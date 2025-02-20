.. _node_type_decorators:


Node-type Decorators
====================

Roadiz allows you to customize any non-structural properties of node types and their fields.

Entity representation
---------------------

This decoration is represented by the NodeTypeDecorator entity, which contains three fields :

    - ``path``
    - ``property``
    - ``value``

``path`` property :
^^^^^^^^^^^^^^^^^^^

This property is used to define the *node type* or *node type field* we want to customize.

It consists of the ``node type name`` and the ``node type field name`` separated by a ``dot``.

.. note::
    Exemple of ``path`` for the content field of a Page :

    ``Page.content``

.. warning::
    For decorate an property of a node type simply leave empty after the dot. :

    ``Page.``


``property`` property :
^^^^^^^^^^^^^^^^^^^

This property is used to define the *node type property* or *node type field property* we want to customize.

It consist of a ``Enum`` who depend if the path contain a field or not.

**List of the property for node type :**

#. displayName
#. description
#. color

**List of the property for node type field :**

#. field_label
#. field_universal
#. field_description
#. field_placeholder
#. field_visible
#. field_min_length
#. field_max_length

.. note::
    Exemple of ``property`` for the content field of a Page :

    ``field_label``

.. warning::
    You can't attribute a ``node type`` property to a ``path`` with field
    (exemple: path = ``Page.`` and property = ``field_label``)

    You can't attribute a ``node type field`` property to a ``path`` without field
    (exemple: path = ``Page.content`` and property = ``displayName``)

``value`` property :
^^^^^^^^^^^^^^^^^^^

This property is used to define the value who override default.

It consists of a string linked to its property type.

List of the property type :

    - **displayName** => text type
    - **description** => text type
    - **color** => hexadecimal color type
    - **field_label** => text type
    - **field_universal** => boolean type
    - **field_description** => text type
    - **field_placeholder** => text type
    - **field_visible** => boolean type
    - **field_min_length** => integer type
    - **field_max_length** => integer type

.. note::
    Exemple of ``value`` on the ``field_label`` property :
    ``'A text Label'``

    Exemple of ``value`` on the ``field_visible`` property :
    ``'true'``

    Exemple of ``value`` on the ``color`` property :
    ``'#FF1185'``

    Exemple of ``value`` on the ``field_max_length`` property :
    ``'15'``
