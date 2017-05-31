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

Adding custom form to your theme
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you want to integrate your custom-forms into your theme, you can use Roadiz
``CustomFormHelper`` class to generate a standard ``FormInterface`` and to
create a view into your theme templates.

First you must create a dedicated action for your node or your block
if you used ``{{ nodeSource|render(@AwesomeTheme) }}`` Twig filter.

.. code-block:: php
   :linenos:

    use RZ\Roadiz\Core\Entities\CustomForm;
    use RZ\Roadiz\Core\Exceptions\EntityAlreadyExistsException;
    use RZ\Roadiz\Core\Exceptions\ForceResponseException;
    use RZ\Roadiz\Utils\CustomForm\CustomFormHelper;
    use Symfony\Component\Form\FormError;
    use Symfony\Component\HttpFoundation\JsonResponse;

    // …

    /*
     * Get your custom form instance from your node-source
     * only if you added a *custom-form reference field*.
     */
    $customForms = $this->nodeSource->getCustomformReference();
    if (isset($customForms[0]) && $customForms[0] instanceof CustomForm) {
        /** @var CustomForm $customForm */
        $customForm = $customForms[0];

        /*
         * Verify if custom form is still open
         * for answers
         */
        if ($customForm->isFormStillOpen()) {
            /*
             * CustomFormHelper will generate Symfony form against
             * Roadiz custom form entity.
             * You can add a Google Recaptcha passing following options.
             */
            $helper = new CustomFormHelper($this->get('em'), $customForm);
            $form = $helper->getFormFromAnswer($this->get('formFactory'), null, true, [
                'recaptcha_public_key' => $this->get('settingsBag')->get('recaptcha_public_key'),
                'recaptcha_private_key' => $this->get('settingsBag')->get('recaptcha_private_key'),
                'request' => $request,
            ]);
            $form->handleRequest($request);

            if ($form->isSubmitted() && $form->isValid()) {
                try {
                    $answer = $helper->parseAnswerFormData($form, null, $request->getClientIp());

                    if ($request->isXmlHttpRequest()) {
                        $response = new JsonResponse([
                            'message' => $this->getTranslator()->trans('form_has_been_successfully_sent')
                        ]);
                    } else {
                        $this->publishConfirmMessage(
                            $request,
                            $this->getTranslator()->trans('form_has_been_successfully_sent')
                        );
                        $response = $this->redirect($this->generateUrl($this->nodeSource->getHandler()->getParent()));
                    }
                    /*
                     * If you are in a BlockController use ForceResponseException
                     */
                    throw new ForceResponseException($response);
                    /*
                     * Or directly return redirect response.
                     */
                    //return $response;
                } catch (EntityAlreadyExistsException $e) {
                    $form->addError(new FormError($e->getMessage()));
                }
            }

            $this->assignation['session']['messages'] = $this->get('session')->getFlashBag()->all();
            $this->assignation['form'] = $form->createView();
        }
    }


If you didn’t do it yet, create a custom form theme in your ``views/`` folder:

.. code-block:: html+jinja
   :linenos:

    {#
     # AwesomeTheme/Resources/views/form.html.twig
     #}
    {% extends "bootstrap_3_layout.html.twig" %}

    {% block form_row -%}
        <div class="form-group form-group-{{ form.vars.block_prefixes[1] }} form-group-{{ form.vars.name }}">
            {% if form.vars.block_prefixes[1] != 'separator' %}
                {{- form_label(form) -}}
            {% endif %}
            {{- form_errors(form) -}}
            {#
             # Render field description inside your form
             #}
            {% if form.vars.attr['data-description'] %}
                <div class="form-description">
                    {{ form.vars.attr['data-description']|markdown }}
                </div>
            {% endif %}
            {{- form_widget(form) -}}
        </div>
    {%- endblock form_row %}

    {% block recaptcha_widget -%}
        <div class="g-recaptcha" data-sitekey="{{ configs.publicKey }}"></div>
    {%- endblock recaptcha_widget %}

In your main view, add your form and use your custom form theme:

.. code-block:: html+jinja
   :linenos:

    {#
     # AwesomeTheme/Resources/views/form-blocks/customformblock.html.twig
     #}
    {% if form %}
        {% form_theme form '@AwesomeTheme/form.html.twig' %}
        {{ form_start(form) }}
        {{ form_widget(form) }}
        <div class="form-group">
            <button class="btn btn-primary" type="submit">{% trans %}send_form{% endtrans %}</button>
        </div>
        {{ form_end(form) }}
    {% else %}
        <p class="alert alert-warning">{% trans %}form_is_not_available{% endtrans %}</p>
    {% endif %}