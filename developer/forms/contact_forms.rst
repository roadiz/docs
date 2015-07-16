.. _contact-forms:

======================
Building contact forms
======================

With Roadiz you can easily create simple contact forms with ``ContactFormManager`` class. Your controller has
a convenient shortcut to create this manager with ``$this->createContactFormManager()`` method.

If you want to add your own fields, you can use the manager’ form-builder with ``$contactFormManager->getFormBuilder();``.
Then add your field using standard *Symfony* form syntax. Do not forget to use *Constraints* to handle errors.

One contact-form for one action
-------------------------------

Here is an example to create your contact form in your controller action.

.. code-block:: php
   :linenos:

    use Symfony\Component\Validator\Constraints\File;

    …
    // Create contact-form manager and add 3 default fields.
    $contactFormManager = $this->createContactFormManager()
                               ->withDefaultFields();
    /*
     * (Optional) Add custom fields…
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

Using contact-form in *block* controllers
-----------------------------------------

If you want to use *contact-forms* in blocks instead of a full page, you will need
to make your redirection response **bubble** through *Twig* render. The only way to stop
Twig is to **throw an exception** and to pass your Redirect or Json response within your
Exception.

Roadiz makes this possible with ``RZ\Roadiz\Core\Exceptions\ForceResponseException``.
For example, in a ``Themes\MyAwesomeTheme\Controllers\Blocks\ContactBlockController``, instead of
returning the ``contactFormManager`` response, you will have to throw a ``ForceResponseException``
with it as an argument.

.. code-block:: php
   :linenos:

    // ./themes/MyAwesomeTheme/Controllers/Blocks/ContactBlockController.php

    use RZ\Roadiz\Core\Exceptions\ForceResponseException;

    …
    // Create contact-form manager and add 3 default fields.
    $contactFormManager = $this->createContactFormManager()
                               ->withDefaultFields();

    if (null !== $response = $contactFormManager->handle()) {
        /*
         * Force response to bubble through Twig rendering process.
         */
        throw new ForceResponseException($response);
    }

    $form = $contactFormManager->getForm();

    // Assignate your form view to display it in Twig.
    $this->assignation['contactForm'] = $form->createView();

    return $this->render('blocks/contactformblock.html.twig', $this->assignation);

Then, in your *master* controller (i.e. ``PageController``), ``render`` method will automatically
catch your *ForceResponseException* exception in order to extract the forced response object. Then
it will return your response instead of your page twig rendered output.


