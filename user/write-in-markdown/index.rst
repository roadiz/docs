.. _writing_in_markdown:

Write in Markdown
=================

    Markdown is a lightweight markup language with plain text formatting syntax designed so that it can be converted to HTML and many other formats using a tool by the same name. […] The key design goal is readability – that the language be readable as-is, without looking like it has been marked up with tags or formatting instructions, unlike text formatted with a markup language, such as Rich Text Format (RTF) or HTML, which have obvious tags and formatting instructions.

    -- Wikipedia article — https://en.wikipedia.org/wiki/Markdown

Titles
------

**Add two hashtag** ``#`` **or more according to your title importance level.**
Backoffice shortcut buttons allow to directly insert your titles marks before your selected text. Make sure to leave a blank line before each new title you write.
::
    ## Architecture
    ### Modern architecture

Be careful not to use only one hashtag to create a first-level title as this
is usually used for pages main title.

Alternate syntax
^^^^^^^^^^^^^^^^

Main title and second level titles can be written using ``=`` and ``-`` as
underline characters.
::
    Architecture
    ============

    Modern architecture
    -------------------


Bold
----

**Insert two stars** ``*`` **before and after your text to set in bold.**
Backoffice shortcut button allows to insert directly the 4 characters around your selected text.
::
    This is a **bold text.** And a normal one.

Be careful not to leave whitespaces inside your stars group (in the same
way you do with parenthesis) otherwise your text won’t be styled.

Italic
------

**Insert one star** ``*`` **before and after your text to set in italic.**
Backoffice shortcut button allows to insert directly the 2 characters around your selected text.
::
    This is an *italic text.* And a normal one.

Bold and italic marks can of course be combined using 3 stars before and after your selected text.

What if * character is already in use
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bold and italic markup can be performed using ``_`` (underscore) character
too if you actually need to write a *star* character in your text.
::
    A __3* Bed & Breakfast__ has just opened its doors in middletown.

Strike-through
--------------

**Insert two tildes** ``~`` **before and after your text to strike-through.**
::
    This is ~~striked-through text~~.

Ordered and unordered lists
---------------------------

**Insert a star** ``*`` **or a dash** ``-`` **followed by a single whitespace for each of your list item.**
One item per line. Leave a blank line before and after your list. For *ordered* list, use a digit followed by a dot and a whitespace instead.
::
    * A line
    - An other line
    * A unknown line

    1. The first item
    2. The second item
    3. The third item

If you need to break an item into several lines, you’ll need to use the line-break markup.

Nested list
^^^^^^^^^^^

You can insert a second/third/… level for your list, just **by leaving four spaces before your new list-item mark.**
::
    - A list item
        - A sub-item
        - A second sub-item
            1. An ordered sub-sub-item
            2. The second sub-sub-item


New paragraph and line-break
----------------------------

A simple line-break is always ignored by Markdown language because it makes a difference between a **paragraph** and a **line-break**.
To simply create a line-break without creating a new paragraph, **leave at least 3 spaces at the end of your text line then go to a new line.**
::
    Address:<space><space><space>
    26 rue Burdeau<space><space><space>
    69001 Lyon<space><space><space>
    France

To create a new paragraph, **always leave a blank line between your text blocks.** Any additional blank line will be ignored.
::
    Nullam quis risus eget urna mollis ornare vel eu leo.
    Cras justo odio, dapibus ac facilisis in, egestas eget quam.

    Aenean eu leo quam. Pellentesque ornare sem lacinia
    quam venenatis vestibulum.

According to your website design (CSS), new paragraphs may have no visual margins between them.
Inserting more than one blank line won’t add any additional visual space as Markdown ignores it.

Hypertext links
---------------

**Write link label between braces immediately followed by the URL between parenthesis.** For external links
do not forget protocol prefix ``http://`` or ``https://``.
::
    [My link](http://www.google.com)

To create a internal link, just use relative notation:
::
    [Contact us](/page/contact-us)

Then, for an email link, use ``mailto:`` prefix:
::
    [John Doe](mailto:jdoe@example.com)

A link title can be added by inserting it before *ending parenthesis* wrapped in quotes.
::
    [My link](http://www.google.com "Link to Google website")

Block quotes
------------

**Insert a** ``>`` **sign before each new paragraph and a space** to wrap your text in a
quote block. You can then use all other Markdown symbols inside your quote.
::
    > ### Donec ullamcorper nulla non metus auctor fringilla.
    > Aenean lacinia **bibendum** nulla sed consectetur.
    > Vestibulum id ligula porta felis euismod semper.

Images
------

**Images use the link syntax with an exclamation mark prefix** ``!``. For external images
do not forget to write full URL with protocol ``http://`` or ``https://``.
::
    ![A cat](/files/cat.jpg)

    ![A cat from an other website](https://www.example.com/images/cat.jpg)

Be careful, images will be displayed as is, unless your webdesigner planned to adapt image
size coming from Markdown fields using CSS. As links, an external image may break if its owner
deletes the original image. Make sure to host critical images directly on your website and to use *relative URL*.

Footnotes
---------

Footnotes are not supported with *basic* Markdown syntax, but the *Markdown Extra* one. So before
using them, **make sure your webdesigner used the right Markdown parser in your theme.**
::
    Praesent commodo cursus magna[^note], Sed posuere consectetur est at
    lobortis. Vel scelerisque nisl consectetur et[^othernote].

    [^note]: This a footnote
    [^othernote]: This a second footnote

Markdown will *automatically generate anchor links between your footnote and its reference*.
It will automatically **use numbers as footnote reference labels**, so you don’t have to bother to write
numbers yourself but easy-to-remember markers labels.

