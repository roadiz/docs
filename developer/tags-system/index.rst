.. _tags-system-intro:

==========
Tag system
==========

Nodes are essentially hierarchical entities. So we created an entity to link nodes between them no matter where/what
they are. Tags are meant as *tag* nodes, we couldn’t be more explicit. But if you didn’t understand here is a schema:

.. image:: ./tags.*
   :align: center


You can see that tags can gather heterogenous nodes coming from different types (pages and projects).
Tags can be used to display a category-navigation on your theme or to simply tidy your backoffice node database.

Did you notice that ``Tags`` are related to ``Nodes`` entities, not ``NodesSources``? We thought that it would be
easier to manage that way not to forget to tag a specific node translation.
It means that you won’t be able to differenciate tag two ``NodesSources``, if you absolutely need to, we encourage you to create two different nodes.

Translate tags
--------------

You will notice that tags work the same way as nodes do. By default, tags names can’t contain special characters in order to be used in URLs.
So we created ``TagTranslation`` entities which stand for Tag’s sources:

.. image:: ./tag-translations.*
   :align: center

In that way you will be able to translate your tags for each available languages.

Tag hierarchy
-------------

In the same way as *Nodes* work, tags can be nested to create *tag groups*.

Displaying node-source’ tags with Twig
--------------------------------------

.. code-block:: html+jinja

    {% set tags = nodeSource|tags %}

    <ul>
    {% for tag in tags %}
        {% set tagTranslation = tag.translatedTags.first %}
        <li id="{{ tag.tagName }}">{{ tagTranslation.name }}</li>
    {% endfor %}
    </ul>
