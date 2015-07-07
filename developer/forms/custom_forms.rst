.. _custom-forms:

=====================
Building custom forms
=====================

Building a custom is look like a node building but it's a lot more simple!
Let's have a look on structure image.

.. image:: ./img/custom-form.*
    :align: center

When you create custom form you add some question. The questions are the CustomFormField type.

The answer is saved in two entities:
    - in CustomFormAnswer
    - in CustomFormFieldAttribute

The CustomFormAnswer will store the IP and the submitted time. While question answer will be in CustomFormFieldAttribute with the CustomFormAnswer id and the CustomFormField id.
