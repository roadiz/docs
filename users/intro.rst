.. _managing_users:

Managing users
==============

    It's possible to manage user with roadiz CLI.

Add user
--------

    The command ``bin/roadiz  core:users --create loginname`` start a new interactive user creation session.

    It's kinda basical. You will create a new user with login and email, you can also choose if it's a backend user and if it's a superadmin.

Delete user
-----------

    The command ``bin/roadiz  core:users --delete loginname`` delete the user "loginname".

Adding role
-----------

    You can add role to user. If you want to add superadmin role to user "test", this will be the commande.

    .. code-block:: console

        bin/roadiz  core:users test --add-roles ROLE_SUPERADMIN

    You can add multiple role at the same time, you just need to use the separator "," without space.

Other action
------------

    It's possible to enable or disable user with ``--enable`` or ``--disable`` argument.
    If a user don't remember password, you can regenerate it with the ``--regenerate`` argument.

    For more information and more action, I invite you to use the commande:

    .. code-block:: console

        bin/roadiz  core:users --help
