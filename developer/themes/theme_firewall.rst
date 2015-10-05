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

Configuring a firewall map entry
--------------------------------

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

    use RZ\Roadiz\Core\Authentification\AuthenticationFailureHandler;
    use RZ\Roadiz\Core\Authentification\AuthenticationSuccessHandler;
    use Symfony\Component\HttpFoundation\RequestMatcher;
    use Symfony\Component\Security\Core\Authentication\AuthenticationTrustResolver;
    use Symfony\Component\Security\Http\EntryPoint\FormAuthenticationEntryPoint;
    use Symfony\Component\Security\Http\Firewall\ExceptionListener;
    use Symfony\Component\Security\Http\Firewall\LogoutListener;
    use Symfony\Component\Security\Http\Firewall\UsernamePasswordFormAuthenticationListener;
    use Symfony\Component\Security\Http\Logout\DefaultLogoutSuccessHandler;
    use Symfony\Component\Security\Http\Logout\SessionLogoutHandler;
    use Symfony\Component\Security\Http\Session\SessionAuthenticationStrategy;


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

        /*
         * Define firewall map base path
         */
        $requestMatcher = new RequestMatcher($firewallBasePattern);
        /*
         * Enforce required ROLE for this area
         */
        $container['accessMap']->add($requestMatcher, [$firewallBaseRole]);
        /*
         * Logout listener
         */
        $logoutListener = new LogoutListener(
            $container['securityTokenStorage'],
            $container['httpUtils'],
            new DefaultLogoutSuccessHandler(
                $container['httpUtils'],
                $firewallLogin
            ),
            [
                'logout_path' => $firewallLogout,
            ]
        );
        $logoutListener->addHandler(new SessionLogoutHandler());
        $logoutListener->addHandler($container['cookieClearingLogoutHandler']);

        $listeners = [
            // manages the SecurityContext persistence through a session
            $container['contextListener'],
            // logout users
            $logoutListener,
            $container['rememberMeListener'],
            // authentication via a simple form composed of a username and a password
            new UsernamePasswordFormAuthenticationListener(
                $container['securityTokenStorage'],
                $container['authentificationManager'],
                new SessionAuthenticationStrategy(SessionAuthenticationStrategy::MIGRATE),
                $container['httpUtils'],
                Kernel::SECURITY_DOMAIN,
                new AuthenticationSuccessHandler(
                    $container['httpUtils'],
                    $container['em'],
                    $container['tokenBasedRememberMeServices'],
                    [
                        'always_use_default_target_path' => false,
                        'default_target_path' => $firewallBasePath,
                        'login_path' => $firewallLogin,
                        'target_path_parameter' => '_target_path',
                        'use_referer' => true,
                    ]
                ),
                new AuthenticationFailureHandler(
                    $container['httpKernel'],
                    $container['httpUtils'],
                    [
                        'failure_path' => $firewallLogin,
                        'failure_forward' => false,
                        'login_path' => $firewallLogin,
                        'failure_path_parameter' => '_failure_path',
                    ],
                    $container['logger']
                ),
                [
                    'check_path' => $firewallLoginCheck,
                ],
                $container['logger'],
                $container['dispatcher'],
                null
            ),
            $container['securityAccessListener'],
            $container["switchUser"],
        ];
        $formEntryPoint = new FormAuthenticationEntryPoint(
            $container['httpKernel'],
            $container['httpUtils'],
            $firewallLogin,
            true
        );
        $exceptionListener = new ExceptionListener(
            $container['securityTokenStorage'],
            new AuthenticationTrustResolver('', ''),
            $container['httpUtils'],
            Kernel::SECURITY_DOMAIN,
            $formEntryPoint,
            null,
            null,
            $container['logger']
        );

        /*
         * Finally add this long long configuration to the Roadiz
         * firewall map.
         */
        $container['firewallMap']->add($requestMatcher, $listeners, $exceptionListener);

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
        Request $request
    ) {
        $this->prepareThemeAssignation(null, null);
        $helper = $this->getService('securityAuthenticationUtils');
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
        <div data-uk-alert class="uk-alert uk-alert-danger">{{ error.message|trans }}</div>
    {% endif %}
    <form id="login-form" class="uk-form uk-form-stacked {% if error %}uk-animation-shake{% endif %}" action="{{ path('themeLoginCheck') }}" method="post">
        <div class="uk-form-row">
            <label class="uk-form-label" for="_username">{% trans %}username{% endtrans %}</label>
            <input type="text" name="_username" id="_username" placeholder="{% trans %}username{% endtrans %}" value="" />
        </div>
        <div class="uk-form-row">
            <label class="uk-form-label" for="_password">{% trans %}password{% endtrans %}</label>
            <input type="password" name="_password" id="_password" placeholder="{% trans %}password{% endtrans %}" value="" />
        </div>
        <div class="uk-form-row">
        <button class="uk-button" type="submit"><i class="uk-icon-sign-in"></i> {% trans %}login{% endtrans %}</button>
        </div>
    </form>
