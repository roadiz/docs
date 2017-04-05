.. _theme_firewall:

============================
Add a firewall in your theme
============================

You may need to add a secured area in your website or application, even for none-backend users.
Roadiz uses *Symfony* security components to handle firewalled requests. You will be able to
extend the *firewall map* in your Theme ``setupDependencyInjection`` method.

Before create your firewall map entry, you must understand that Roadiz already has 2 firewall areas:

- ``^/rz-admin`` area, which naturally matches every back-office sections
- ``^/`` area which is required for previewing unpublished node and get user informations across the whole website

The last firewall request matcher can be tricky to deal with, especially if you want to add
another secured area as it *listen* to every requests. When you’ll add your new firewall map entry,
always call ``parent::setupDependencyInjection($container);`` **after** your custom configuration
to be sure that ``^/`` request matcher has **the lowest priority**.

.. code-block:: php

    /**
     * {@inheritdoc}
     */
    public static function setupDependencyInjection(Container $container)
    {
        /*
         * Your custom firewall map entry configuration
         * goes here
         */


        /*
         * Always setup general setupDependencyInjection AFTER
         * theme because of requestMatcher order.
         */
        parent::setupDependencyInjection($container);
    }

Configuring a firewall map entry with FirewallEntry class
---------------------------------------------------------

Before copy and pasting the following lines, think about it a little time…
A firewall map entry defines severals mandatory routes:

- A *base path* for your firewall to be triggered
- A *login* path, which **must** be **outside** of your firewall map
- A *login_check* path, which **must** be **inside** of your firewall map
- A *logout* path, which **must** be **inside** of your firewall map
- A new role describing your secured area purpose (i.e. *ROLE_ACCESS_PRESS* for a private press kit area), you should create this role in Roadiz backoffice before.

If this example I will use:

- ``/press`` as my base path for secured area
- ``/signin`` for my login page, notice that it’s not in my firewall
- ``/press/login_check``
- ``/press/logout``
- *ROLE_ACCESS_PRESS*

Here is the code to add in your theme’ setupDependencyInjection method. Do not forget to
add the matching *use* statement in your file header.

.. code-block:: php

    use RZ\Roadiz\Utils\Security\FirewallEntry;
    use Pimple\Container;

    /**
     * {@inheritdoc}
     */
    public static function setupDependencyInjection(Container $container)
    {
        $firewallBasePattern = '^/press';
        $firewallBasePath = '/press';
        $firewallLogin = '/signin';
        $firewallLogout = '/press/logout';
        $firewallLoginCheck = '/press/login_check';
        $firewallBaseRole = 'ROLE_ACCESS_PRESS';

        $firewallEntry = new FirewallEntry(
            $container,
            $firewallBasePattern,
            $firewallBasePath,
            $firewallLogin,
            $firewallLogout,
            $firewallLoginCheck,
            $firewallBaseRole
            // You can add a special AuthenticationSuccessHandler
            // if you need to do some stuff for your theme at visitor login
            //'Themes\YourTheme\Authentification\AuthenticationSuccessHandler'
        );
        // Allow anonymous authentification
        $firewallEntry->withAnonymousAuthenticationListener();
        // Allow switch user feature
        $firewallEntry->withSwitchUserListener();

        /*
         * Finally add this entry to the Roadiz
         * firewall map.
         */
        $container['firewallMap']->add(
            $firewallEntry->getRequestMatcher(),
            $firewallEntry->getListeners(),
            $firewallEntry->getExceptionListener()
        );

        /*
         * Always setup general setupDependencyInjection AFTER
         * theme because of requestMatcher order.
         */
        parent::setupDependencyInjection($container);
    }

Add login routes
----------------

After configuring your Firewall, you’ll need to add your routes to your theme ``routes.yml`` file.
*Logout* and *login_check* won’t need any controller setup as they will be handled directly by Roadiz firewall
event dispatcher. The only one you need to handle is the *login* page.

.. code-block:: yaml

    themeLogout:
        path:     /press/logout
    themeLoginCheck:
        path:     /press/login_check
    themeLoginPage:
        path:     /signin
        defaults: { _controller: Themes\MySuperTheme\Controllers\LoginController::loginAction }

In your ``LoginController``, just add error handling from the ``securityAuthenticationUtils`` service to display a
feedback on your login form:

.. code-block:: php

    /**
     * {@inheritdoc}
     */
    public function loginAction(
        Request $request,
        $_locale = 'en'
    ) {
        $translation = $this->bindLocaleFromRoute($request, $_locale);
        $this->prepareThemeAssignation(null, $translation);
        $helper = $this->get('securityAuthenticationUtils');
        $this->assignation['last_username'] = $helper->getLastUsername();
        $this->assignation['error'] = $helper->getLastAuthenticationError();

        return $this->render('press/login.html.twig', $this->assignation);
    }

Then, you can create your *login* form as you want. Just use the required fields:

- ``_username``
- ``_password``

And do not forget to set your form *action* to ``{{ path('themeLoginCheck') }}`` and to use *POST* method.

.. code-block:: html+jinja

    {% if error %}
        <div class="alert alert-danger"><i class="fa fa-warning"></i> {{ error.message|trans }}</div>
    {% endif %}
    <form id="login-form" class="form" action="{{ path('themeLoginCheck') }}" method="post">
        <div class="form-group">
            <label class="control-label" for="_username">{% trans %}username{% endtrans %}</label>
            <input class="form-control" type="text" name="_username" id="_username" placeholder="{% trans %}username{% endtrans %}" value="" />
        </div>
        <div class="form-group">
            <label class="control-label" for="_password">{% trans %}password{% endtrans %}</label>
            <input class="form-control" type="password" name="_password" id="_password" placeholder="{% trans %}password{% endtrans %}" value="" />
        </div>
        <div class="form-group">
            <label class="control-label" for="_remember_me">{% trans %}keep_me_logged_in{% endtrans %}</label>
            <input class="form-control" type="checkbox" name="_remember_me" id="_remember_me" value="1" />
        </div>
        <div class="form-group">
            <button class="btn btn-primary" type="submit"><i class="fa fa-signin"></i> {% trans %}login{% endtrans %}</button>
        </div>
    </form>
