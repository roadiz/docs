.. _managing_users:

Managing users
==============

It's possible to manage users with roadiz CLI.

Add user
--------

The command ``bin/roadiz  core:users --create loginname`` starts a new interactive user creation session.
It's kinda basical. You will create a new user with login and email, you can also choose if it's a backend user and if it's a superadmin.

Delete user
-----------

The command ``bin/roadiz  core:users --delete loginname`` delete the user "loginname".

Adding role
-----------

You can add roles to users. If you want to add ``ROLE_SUPERADMIN`` role to user "test", this will be the command.

.. code-block:: console

    bin/roadiz  core:users test --add-roles ROLE_SUPERADMIN

You can add multiple roles at the same time, you just need to use the "," separator without space.

Other action
------------

It's possible to enable or disable users with ``--enable`` or ``--disable`` argument.
If a user doesn't remember his password, you can regenerate it with the ``--regenerate`` argument.

For more informations and more actions, we invite you to use the command:

.. code-block:: console

    bin/roadiz  core:users --help
