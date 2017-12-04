.. _send_emails:

================================
Sending emails from your website
================================

``emailManager`` factory service is available to send emails from your application.
It’s already configured to use simple CSS styles and you can use an HTML and plain-text
templates.

.. code-block:: php

    $request = $this->get('request');
    $receiver = 'dest@test.com';
    $origin = $this->get('settingsBag')->get('email_sender');

    $emailManager = $this->get('emailManager');
    $title = $this->getTranslator()->trans('hello_world');
    $emailManager->setEmailTitle($title);
    $emailManager->setSubject($title);
    $emailManager->setReceiver($receiver);
    $emailManager->setOrigin($origin);

    $emailManager->setAssignation([
        'content' => 'Bla bla bla',
        'title' => $title,
        'head' => [
            'absoluteResourcesUrl' => $request->getSchemeAndHttpHost() . $request->getBasePath() . '/themes/MySuperTheme/static/',
        ],
        'site' => $this->get('settingsBag')->get('site_name'),
        'disclaimer' => 'You are receiving this email because you rocks!',
    ]);
    $emailManager->setEmailTemplate('@MySuperTheme/emails/email.html.twig');
    $emailManager->setEmailPlainTextTemplate('@MySuperTheme/emails/email.txt.twig');
    $emailManager->send();

Assignation works the same way as HTML template for your website, you must assign every
content and informations you’ll need to print in your emails.

.. note::

    Be careful, every image path or links **must be** an absolute URL, not a path as your
    receivers won’t be able to resolve your full domain name. Make sure you are using ``url()``
    instead of ``path()`` for links and add ``head.absoluteResourcesUrl`` prefix for your static
    assets (like in the example before).

Your `emails/email.html.twig` template should inherits from Roadiz `base_email.html.twig` template.

.. code-block:: html+twig

    {% extends 'base_email.html.twig' %}

    {% block title %}<title>{{ title }}</title>{% endblock %}

    {% block content_table %}
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td class="content-block">
                    <h1>{{ title }}</h1>
                </td>
            </tr>
            <tr>
                <td class="content-block">{{ content|markdown }}</td>
            </tr>
        </table>
    {% endblock %}

Your `emails/email.txt.twig` template should inherits from Roadiz `base_email.txt.twig` template.

.. code-block:: html+twig

    {% extends 'base_email.txt.twig' %}

    {% block title %}{{ title }}{% endblock %}
    {% block content_table %}{{ content|markdown|strip_tags }}{% endblock %}

