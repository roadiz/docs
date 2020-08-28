.. Roadiz documentation master file, created by Ambroise Maupate

==================================
Welcome to Roadiz's documentation!
==================================

Roadiz is a polymorphic CMS based on a node system that can handle many types of services.
It is based on *Symfony* components, *Doctrine ORM*, *Twig* and *Pimple* for maximum performances and security.

Roadiz node system allows you to create your data schema and to organize your content as you want.
We designed it to break technical constraints when you create tailor-made websites architectures and layouts.

Imagine you need to display your graphic design portfolio and… sell some t-shirts. With Roadiz you will be able to create your content forms from scratch and choose the right fields you need. Images and texts for your projects.
Images, texts, prices and even geolocation for your products. That’s why it’s called *polymorphic*.

.. _philosophy:

Philosophy
----------

When discovering Roadiz back-office interface, you will notice that there aren’t any Rich text editor also called *WYSIWYG* editors. We chose to promote *Markdown* syntax in order to focus on content hierarchy and quality
instead of content style. Our guideline is to preserve and respect the webdesigners' and graphic designers' work.

You’ll see that we built Roadiz as webdesigners and for webdesigners. It will allow you to create really quickly website
prototypes using *Twig* templates. But as the same time you will be able to get the power of the *Symfony* and *Doctrine* core components
to build complex applications.

We also decided to be really strict about Plugins and other addons modules. How many of you do not upgrade your Wordpress website because of plugin dependencies? We decided not to build Roadiz around a “Plugin” system but a **Theme system**, as every Roadiz extensions will have to serve a theme’s features. Themes will enable you to create awesome website layouts but also great back-office additions for your customers. You will be able to centralize all your custom code in one place, so you can use a versioning tool such as Git.

Roadiz theme system will allow you to daisy-chain themes and dispatch features on multiple code. As our CMS is built on Pimple dependency injection container, Roadiz can merge every available themes on the same website. For example, you will be able to create one portfolio theme using Node-system Urls and unlimited static themes which will use a static routing scheme, for a Forum or a Blog or even both! Theme system will even allow you to create additional Doctrine entities and extend our back-office. Yes, just sit on your theme code and you can extend Roadiz to create a manager for your Forum. Cherry on the cake, you can assign each theme to a specific domain name to create mobile or media specific layouts. Believe me, this cake is not a lie.

We want Roadiz to be a great tool for designers and developers to build strong web experiences together. But we thought of editors too! Roadiz back-office theme “Rozier” has been designed to offer every back-users a great writing and administrating experience.

User documentation
------------------

.. toctree::
   :maxdepth: 2

   user/index.rst

Developer documentation
-----------------------

.. toctree::
   :maxdepth: 2

   developer/index.rst

Extension documentation
-----------------------

.. toctree::
   :maxdepth: 2

   extension/index.rst
