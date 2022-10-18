.. _extending_serialization:

Extending serialization
=======================

Imagine you created a *BlogPost* node-type, and you want to give users a preview of your latest BlogPosts in your
website home page. You would create:

- A ``BlogPost`` node-type
- and a ``BlogPostFeedBlock`` node-type
- and your ``Page`` node-type would have a ``blocks`` field allowing ``BlogPostFeedBlock`` creation

When you hit ``/api/web_response_by_path?path=/`` you should expect your ``WebResponse`` blocks section to expose your
``BlogPostFeedBlock``. But how do you expose automatically the latest 3 blog-posts? You could add a node-reference field
in your ``BlogPostFeedBlock`` and ask your editor to **manually** expose 3 blog-posts. But this won't be automatic at all.

Using a custom Normalizer
-------------------------

One solution is to extend ``BlogPostFeedBlock`` normalization stage. With this technique you will be able to inject
additional data into your serialized object.

First, create a Normalizer which will **decorate** Roadiz and API Platform default item normalizers:

.. code-block:: php

    <?php

    declare(strict_types=1);

    namespace App\Serializer\Normalizer;

    use App\GeneratedEntity\NSBlogPostFeedBlock;
    use App\GeneratedEntity\NSBlogPost;
    use Doctrine\ORM\Tools\Pagination\Paginator;
    use RZ\Roadiz\CoreBundle\EntityApi\NodeSourceApi;
    use RZ\Roadiz\CoreBundle\Serializer\Normalizer\AbstractPathNormalizer;
    use Symfony\Component\Routing\Generator\UrlGeneratorInterface;
    use Symfony\Component\Serializer\Normalizer\NormalizerInterface;

    final class BlogPostFeedBlockNormalizer extends AbstractPathNormalizer
    {
        public NodeSourceApi $nodeSourceApi;

        public function __construct(
            NodeSourceApi $nodeSourceApi,
            NormalizerInterface $decorated,
            UrlGeneratorInterface $urlGenerator
        ) {
            parent::__construct($decorated, $urlGenerator);
            $this->nodeSourceApi = $nodeSourceApi;
        }

        /**
         * @param mixed $object
         * @param string|null $format
         * @param array $context
         * @return array|\ArrayObject|bool|float|int|mixed|string|null
         * @throws \Symfony\Component\Serializer\Exception\ExceptionInterface
         */
        public function normalize($object, $format = null, array $context = [])
        {
            $data = $this->decorated->normalize($object, $format, $context);
            if (
                $object instanceof NSBlogPostFeedBlock &&
                is_array($data)
            ) {
                // fetch latest 3 blog-posts from DB
                $blogPosts = $this->nodeSourceApi->getBy(
                    [
                        'node.nodeType.name' => 'BlogPost',
                        'node.visible' => true,
                        'publishedAt' => ['<=', new \DateTime()]
                    ],
                    [
                        'publishedAt' => 'DESC'
                    ],
                    3
                );

                if ($blogPosts instanceof Paginator) {
                    $blogPosts = $blogPosts->getIterator()->getArrayCopy();
                }

                $data['blogPosts'] = array_map(
                    function (NSBlogPost $blogPost) use ($format, $context) {
                        // Call decorated normalizer to normalize your BlogPosts
                        // Be careful to set properly your service decoration priority!
                        return $this->decorated->normalize($blogPost, $format, $context);
                    },
                    $blogPosts
                );
            }
            return $data;
        }
    }

Then register your custom normalizer in your app ``services.yaml`` with a very low decoration priority setting to be sure
your normalizer will be decorating **after** Roadiz and API Platform normalizers.

.. code-block:: yaml

    # config/services.yaml
    services:
        # ...
        App\Serializer\Normalizer\BlogPostFeedBlockNormalizer:
            decorates: 'api_platform.jsonld.normalizer.item'
            # normalizer must be decorating after Roadiz and API Platform normalizers
            decoration_priority: -1
        # Need a different name to avoid duplicate YAML key
        app.serializer.normalizer.blog_post_feed_block.json:
            class: 'App\Serializer\Normalizer\BlogPostFeedBlockNormalizer'
            decorates: 'api_platform.serializer.normalizer.item'
            # normalizer must be decorating after Roadiz and API Platform normalizers
            decoration_priority: -1

If your service is well registered, you should see your ``BlogPostFeedBlock`` exposing a new ``blogPosts``
virtual field with your latest 3 blog-posts:

.. code-block:: json

    {
        "@context": "/api/contexts/WebResponse",
        "@id": "/api/web_response_by_path?path=/",
        "@type": "WebResponse",
        "item": {},
        "breadcrumbs": {},
        "head": {},
        "blocks": [
            {
                "@type": "AutoChildrenNodeSourceWalker",
                "children": [],
                "item": {
                    "@id": "/api/blog_posts_feed_blocks/23",
                    "@type": "BlogPostFeedBlock",
                    "title": "My latest blog-posts",
                    "blogPosts": [
                        {
                            "@id": "/api/blog_posts/22",
                            "@type": "BlogPost",
                            "title": "My super blog post",
                            "publishedAt": "2022-10-14T11:41:15+02:00",
                            "slug": "super-blog-post"
                        },
                        {
                            "@id": "/api/blog_posts/21",
                            "@type": "BlogPost",
                            "title": "My super blog post, but older",
                            "publishedAt": "2022-10-14T11:41:13+02:00",
                            "slug": "super-blog-post-but-older"
                        },
                        {
                            "@id": "/api/blog_posts/20",
                            "@type": "BlogPost",
                            "title": "My super blog post, but older again",
                            "publishedAt": "2022-10-13T11:41:13+02:00",
                            "slug": "super-blog-post-but-older-again"
                        }
                    ]
                }
            }
        }
    }


