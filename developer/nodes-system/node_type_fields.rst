.. _nodes-type-fields:

================
Node-type fields
================

Roadiz can handle many types of node-type fields. Here is a complete list:

.. note ::
    *Title*, *meta-title*, *meta-description* and *keywords* are always available
    since they are stored directly inside ``NodesSources`` entity. Then you will be
    sure to always have a *title* no matter the node-type you are using.

Simple data
^^^^^^^^^^^

This following fields stores simple data in your custom node-source database table.

- Single-line text
- Date
- Date and time
- Basic text
- Markdown text
- Boolean
- Integer number
- Decimal number
- Email
- Color
- Single geographic coordinates
- JSON code
- CSS code
- Country code (ISO 3166-1 alpha-2)
- YAML code
- Many to many join
- Many to one join

.. note ::
    *Single geographic coordinates* field stores its data in JSON format. Make sure you
    don’t have manually writen data in its input field.

.. warning ::
    To use *Single geographic coordinates* you must create a *Google API Console* account with *Maps API v3* activated.
    Then, create a *Browser key* and paste it in “Google Client ID” parameter in Roadiz settings
    to enable *geographic* node-type fields. If you didn’t do it, a simple text input will
    be display instead of *Roadiz Map Widget*.


.. image:: ./img/field-types.*
   :align: center

Virtual data
^^^^^^^^^^^^

Virtual types do not really store data in node-source table. They display custom
widgets in your editing page to link documents, nodes or custom-forms with
your node-source.

- Documents
- Nodes references
- Custom form

Complex data
^^^^^^^^^^^^

These fields types must be created with *default values* (comma separated) in order to
display available default choices for “select-box” types:

- Single choice
- Multiple choices
- Children nodes

*Children node* field type is a special virtual field that will display a custom
node-tree inside your editing page. You can add *quick-create* buttons by listing
your node-types names in *default values* input, comma separated.

Universal fields
^^^^^^^^^^^^^^^^

If you need a field to hold exactly the same data for all translations, you can
set it as *universal*. For example for documents, numeric and boolean data that
do not change from one language to another.

It will duplicate data at each save time from default translation
to others. It will also hide the edit field from non-default translation to avoid
confusion.

YAML field
^^^^^^^^^^

When you use YAML field type, you get an additional method to return your code already parsed.
If your field is named ``data``, your methods will be generated in your *NSEntity* as ``getData()`` and ``getDataAsObject()``.

- ``getData()`` method will return your YAML code as *string*.
- ``getDataAsObject()`` will return a mixed data,array or ``stdObject`` according to your code formatting. This method will throw a ``\Symfony\Component\Yaml\Exception\ParseException`` if your YAML code is not valid.

Many to many and Many to one joins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can create custom relations between your node-source and whatever Doctrine
entities in *Roadiz* or in your theme.

You must fill the *default values* field for these two types.

.. code-block:: yaml

    # Entity class name
    classname: "Themes\MyTheme\Entities\City"
    # Displayable is the method used to display entity name
    displayable: getName
    # Searchable entity fields
    searchable:
        - name
        - slug
    orderBy:
        - field: slug
          direction: ASC
