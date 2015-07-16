.. _contact-forms:

======================
Building contact forms
======================

With Roadiz you can easily create simple contact forms with ``ContactFormManager`` class. Your controller has
a convenient shortcut to create this manager with ``$this->createContactFormManager()`` method.

If you want to add your own fields, you can use the manager’ form-builder with ``$contactFormManager->getFormBuilder();``.
Then add your field using standard *Symfony* form syntax. Do not forget to use *Constraints* to handle errors.

Here is an example to create your contact form in your controller action.

.. code-block:: php
   :linenos:

    use Symfony\Component\Validator\Constraints\File;

    …
    // Create contact-form manager and add 3 default fields.
    $contactFormManager = $this->createContactFormManager()
                               ->withDefaultFields();
    /*
     * Add custom fields…
     */
    $formBuilder = $contactFormManager->getFormBuilder();
    $formBuilder->add('callMeBack', 'checkbox', [
            'label' => 'call.me.back',
            'required' => false,
        ])
        ->add('document', 'file', [
            'label' => 'document',
            'required' => false,
            'constraints' => [
                new File([
                    'maxSize' => $contactFormManager->getMaxFileSize(),
                    'mimeTypes' => $contactFormManager->getAllowedMimeTypes(),
                ]),
            ]
        ])
        ->add('send', 'submit', [
            'label' => 'send.contact.form',
        ]);

    /*
     * This is the most important point. handle method will perform form
     * validation and send email.
     *
     * Handle method should return a Response object if everything is OK.
     */
    if (null !== $response = $contactFormManager->handle()) {
        return $response;
    }

    $form = $contactFormManager->getForm();

    // Assignate your form view to display it in Twig.
    $this->assignation['contactForm'] = $form->createView();

In this example, we used ``withDefaultFields`` method which add automatically ``email``, ``name`` and ``message``
fields with right validation contraints. This method is optional and you can add any field you want manually, just
keep in mind that you should always ask for an ``email``.

Add session messages to your assignations:

.. code-block:: php

    // Get session messages
    $this->assignation['session']['messages'] = $this->getService('session')
                                                     ->getFlashBag()
                                                     ->all();


Then in your contact page Twig template

.. code-block:: html+jinja
   :linenos:

    {#
     # Display contact errors
     #}
    {% if session.messages|length %}
        {% for type, msgs in session.messages %}
            {% for msg in msgs %}
                <div data-uk-alert class="uk-alert
                     uk-alert-{% if type == "confirm" %}success
                     {% elseif type == "warning" %}warning{% else %}danger{% endif %}">
                    <a href="" class="uk-alert-close uk-close"></a>
                    <p>{{ msg }}</p>
                </div>
            {% endfor %}
        {% endfor %}
    {% endif %}
    {#
     # Display contact form
     #}
    {% form_theme contactForm '@MyTheme/forms.html.twig' %}
    {{ form(contactForm) }}
