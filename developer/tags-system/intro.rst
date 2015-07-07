.. _tags-system-intro:

=======================
Tag and tag translation
=======================

Nodes are essentially hierarchical entities. So we created an entity to link nodes between them no matter where/what
they are. Tags are meant to *tag* nodes, we couldn’t be more explicit. But if you didn’t understand here is a schema:

.. image:: ./tags.*
   :align: center


You can see that tags can gather heterogenous nodes coming from different types (pages and projects).
Tags can be used to display a category-navigation on your theme or to simply tidy your backoffice node database.

Did you noticed that ``Tags`` are related to ``Nodes`` entities, not with ``NodesSources``? We though that it would be
easier to manage that way not to forget to tag a specific node translation.
It means that you won’t be able to differently tag two ``NodesSources``, if you absolutely need to, we encourage you to create two different nodes.

Translate tags
--------------

You will notice that tags work the same way as nodes do. By default, tags names can’t contain special characters in order to be used in Urls.
So we created ``TagTranslation`` entities which stand for Tag’s sources:

.. image:: ./tag-translations.*
   :align: center

In that way you will be able to translate your tags for each available languages.

Tag hierarchy
-------------

Tags grow in trees too!
