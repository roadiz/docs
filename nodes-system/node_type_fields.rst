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
- Date and time
- Basic text
- Markdown text
- Boolean
- Integer number
- Decimal number
- Email
- Color
- Single geographic coordinates

.. note ::
    *Single geographic coordinates* field stores its data in JSON format. Make sure you
    don’t have manually writen data in its input field.

.. warning ::
    To use *Single geographic coordinates* you must create a *Google API Console* account with *Maps API v3* activated.
    Then, create a *Browser key* and paste it in “Google Client ID” parameter in Roadiz settings
    to enable *geographic* node-type fields. If you didn’t do it, a simple text input will
    be display instead of *Roadiz Map Widget*.

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
