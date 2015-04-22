.. _contact-forms:

======================
Building contact forms
======================

With Roadiz you can easily create simple contact forms with
`EntryPointsController::getContactFormBuilder <http://api.roadiz.io/RZ/Roadiz/CMS/Controllers/EntryPointsController.html#method_getContactFormBuilder>`_ method.
This will create a ``FormBuilder`` object which points to the Roadiz sendmail entrypoint. You just have to add your own
form inputs like the mandatory ``email`` input and assign it to be rendered by Twig.

Create your contact form in your controller action.

.. code-block:: php
   :linenos:

    use RZ\Roadiz\CMS\Controllers\EntryPointsController;

    ...

    $formBuilder = EntryPointsController::getContactFormBuilder(
        $request,
        true // Force redirection after contact form submit
    );
    $formBuilder->add('email', 'email', array(
                    'label'=>$this->getTranslator()->trans('your.email')
                ))
                ->add('name', 'text', array(
                    'label'=>$this->getTranslator()->trans('your.name')
                ))
                ->add('message', 'textarea', array(
                    'label'=>$this->getTranslator()->trans('your.message')
                ))
                ->add('callMeBack', 'checkbox', array(
                    'label'=>$this->getTranslator()->trans('call.me.back'),
                    'required' => false
                ))
                ->add('send', 'submit', array(
                    'label'=>$this->getTranslator()->trans('send.contact.form')
                ));
    $form = $formBuilder->getForm();
    $this->assignation['contactForm'] = $form->createView();

In this example, we used ``getContactFormBuilder`` method with *redirect* option to *true* (its second argument).
If you need to send your contact form using *Ajax* request, just set this argument to *false* and it will
return a ``JsonResponse`` instead of a ``RedirectResponse``.

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
