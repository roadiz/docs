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
- Multiple geographic coordinates
- JSON code
- CSS code
- Country code (ISO 3166-1 alpha-2)
- YAML code
- Many to many join
- Many to one join
- Single relationship using a provider
- Multiple relationship using a provider
- Custom collection

.. image:: ./img/field-types.*
   :align: center
   :width: 300

Single and multiple geographic coordinates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Geographic coordinates are stored in JSON format in your database using `GeoJSON <https://geojson.org/>`_ schema:

- A single point will be stored as a GeoJSON *feature* in order to hold additional properties such as *zoom*,
- Multiple points will be stored as a GeoJSON *feature collection*

By default, Roadiz back-office uses *Leaflet* library with *Open Street Map* for tiles rendering and basic geo-coding features.

Markdown options
^^^^^^^^^^^^^^^^

You can restrict Markdown fields buttons using the following YAML configuration:

.. code-block:: YAML

    allow_h2: false
    allow_h3: false
    allow_h4: false
    allow_h5: false
    allow_h6: false
    allow_bold: false
    allow_italic: false
    allow_blockquote: false
    allow_list: false
    allow_nbsp: false
    allow_nb_hyphen: false
    allow_image: false
    allow_return: false
    allow_link: false
    allow_hr: false
    allow_preview: false

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

.. code-block:: YAML

    # Entity class name
    classname: Themes\MyTheme\Entities\City
    # Displayable is the method used to display entity name
    displayable: getName
    # Same as Displayable but for a secondary information
    alt_displayable: getZipCode
    # Searchable entity fields
    searchable:
        - name
        - slug
    orderBy:
        - field: slug
          direction: ASC

You can use a custom proxy entity to support persisting ``position`` on your relation. Roadiz will generate a one-to-many
relationship with proxy entity instead of a many-to-many.
In this scenario you are responsible for creating and migrating ``Themes\MyTheme\Entities\PositionedCity`` entity. If you are migrating from a non-proxied many-to-many relation, you should keep the same table and field names to keep data intact.

.. code-block:: YAML

    # Entity class name
    classname: Themes\MyTheme\Entities\City
    # Displayable is the method used to display entity name
    displayable: getName
    # Same as Displayable but for a secondary information
    alt_displayable: getZipCode
    # Searchable entity fields
    searchable:
        - name
        - slug
    # This order will only be used for explorer
    orderBy:
        - field: slug
          direction: ASC
    # Use a proxy entity
    proxy:
        classname: Themes\MyTheme\Entities\PositionedCity
        self: nodeSource
        relation: city
        # This order will preserve position
        orderBy:
            - field: position
              direction: ASC

Single and multiple provider
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The generic provider type allow you to fetch every data you want through a ``Provider``
class in your theme. This can be really useful if you need to fetch items from an external API
and to reference them in your nodes-sources.

Imagine that you want to link your page with an *Instagram* post. You’ll have to create a class that
extends ``Themes\Rozier\Explorer\AbstractExplorerProvider`` and configure it in your field:

.. code-block:: yaml

    classname: Themes\MyTheme\Provider\ExternalApiProvider

This provider will implement ``getItems``, ``getItemsById`` and other methods from
``ExplorerProviderInterface`` in order to be able to display your *Instagram* posts in
Roadiz explorer widget and to find your selected items back.
Each *Instagram* post will be wrapped in a ``Themes\Rozier\Explorer\AbstractExplorerItem`` that
will map your custom data to the right fields to be showed in Roadiz back-office.

You’ll find an implementation example in Roadiz with ``Themes\Rozier\Explorer\SettingsProvider`` and
``Themes\Rozier\Explorer\SettingExplorerItem``. These classes do not fetch data from an API but from your
database using ``EntityListManager``.

Single and multiple provider types can accept additional options too. If you want to make your provider
configurable at runtime you can pass ``options`` in your field configuration.

.. code-block:: YAML

    classname: Themes\MyTheme\Provider\ExternalApiProvider
    options:
        - name: user
          value: me
        - name: access_token
          value: xxxxx

Then you must override your provider’ ``configureOptions`` method to add which options are allowed.

.. code-block:: php

    use Symfony\Component\OptionsResolver\OptionsResolver;

    /**
     * @param OptionsResolver $resolver
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'page' => 1,
            'search' => null,
            'itemPerPage' => 30,
            // add more default options here
            'user' => 'me',
        ]);
        // You can required options
        $resolver->setRequired('access_token');
    }

Custom collection
^^^^^^^^^^^^^^^^^

Last but not least, you can create a custom collection field to store read-only data using
a dedicated *Symfony* ``AbstractType``.

You must fill the *default values* field for this type:

.. code-block:: YAML

    # AbstractType class name
    entry_type: Themes\MyTheme\Form\FooBarType

You must understand that *custom collection* data will be stored as JSON array in
your database. So you won’t be able to query your node-source using this data.

In your ``FooBarType``, you’ll be able to use *Symfony* standard fields types and
**Roadiz** non-virtual fields too such as ``MarkdownType``, ``JsonType``, ``YamlType``.

