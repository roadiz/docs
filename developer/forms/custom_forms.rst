.. _custom-forms:

=====================
Building custom forms
=====================

Building a custom form looks like building a node but it is a lot simpler!
Let's have a look at structure image.

.. image:: ./img/custom-form.*
    :align: center

After creating a custom form, you add some question. The questions are the CustomFormField type.

The answer is saved in two entities:
    - in CustomFormAnswer
    - in CustomFormFieldAttribute

The CustomFormAnswer will store the IP and the submitted time. While question answer will be in CustomFormFieldAttribute with the CustomFormAnswer id and the CustomFormField id.
