.. _custom-assignations:

===============================
Extending your Twig assignation
===============================

For a simple website theme, base assignation will work for almost every cases.
Using ``node`` or ``nodeSource`` data from your Twig template, you will be able to
render all your pages datas.

Now imagine you need to load data from another node than the one being
requested. Or imagine that you want to create a complex homepage which displays a summary
of your latest news. You will need to extend existing assignated variables.

For example, create a simple node-type called *Page*. Add several basic fields inside it
such as *content* and *images*. If you well-understood :ref:`how to create a theme <create-theme>` section you will
create a *PageController.php* which look like this:

.. code-block:: php

    <?php
    namespace Themes\MyTheme\Controllers;

    use Themes\MyTheme\MyThemeApp;
    use RZ\Roadiz\Core\Entities\Node;
    use RZ\Roadiz\Core\Entities\Translation;

    use Symfony\Component\HttpFoundation\Request;
    use Symfony\Component\HttpFoundation\Response;

    /**
     * Frontend controller to handle Page node-type request.
     */
    class PageController extends MyThemeApp
    {
        /**
         * Default action for any Page node.
         *
         * @param Symfony\Component\HttpFoundation\Request $request
         * @param RZ\Roadiz\Core\Entities\Node              $node
         * @param RZ\Roadiz\Core\Entities\Translation       $translation
         *
         * @return Symfony\Component\HttpFoundation\Response
         */
        public function indexAction(
            Request $request,
            Node $node = null,
            Translation $translation = null
        ) {
            $this->prepareThemeAssignation($node, $translation);

            return new Response(
                $this->getTwig()->render('types/page.html.twig', $this->assignation),
                Response::HTTP_OK,
                array('content-type' => 'text/html')
            );
        }
    }

You will be able to render your page using ``themes/MyTheme/Resources/views/types/page.html.twig``
template file:

.. code-block:: html+jinja

    {% extends 'base.html.twig' %}

    {% block content %}

    <h1>{{ nodeSource.title }}</h1>
    <div class="content">{{ nodeSource.content|markdown }}</div>
    <div class="images">
        {% for document in nodeSource.images %}
            <figure>
                {{ document.viewer.documentByArray()|raw }}
            </figure>
        {% endfor %}
    </div>
    {% endblock %}


Now we need to create links to jump to next and previous pages. So go back to your ``PageController.php``
file to add some assignations.

.. code-block:: php

    …
    $this->prepareThemeAssignation($node, $translation);
    // Add your additional assignations after this method.

    // Use NodesSources API to get next and previous nodes
    // filtering by the same parent node and using current node position
    $this->assignation['nextNodeSource'] =
        $this->getService('nodeSourceApi')
             ->getOneBy(
                 array(
                     'node.parent' => $node->getParent()
                     'node.position' => $node->getPosition() + 1
                 )
             );

    $this->assignation['prevNodeSource'] =
        $this->getService('nodeSourceApi')
             ->getOneBy(
                 array(
                     'node.parent' => $node->getParent()
                     'node.position' => $node->getPosition() - 1
                 )
             );

So we used ``nodeSourceApi`` service which is a Doctrine entity manager wrapper
to easily query over NodesSources entities and filtering with node criteria.

