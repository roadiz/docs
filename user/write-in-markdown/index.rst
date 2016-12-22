.. _writing_in_markdown:

Write in Markdown
=================

    Markdown is a lightweight markup language with plain text formatting syntax designed so that it can be converted to HTML and many other formats using a tool by the same name. […] The key design goal is readability – that the language be readable as-is, without looking like it has been marked up with tags or formatting instructions, unlike text formatted with a markup language, such as Rich Text Format (RTF) or HTML, which have obvious tags and formatting instructions.

    -- Wikipedia article — https://en.wikipedia.org/wiki/Markdown

Titles
------

**Add two hashtag** ``#`` **or more according to your title importance level.**
Backoffice shortcut buttons allow to directly insert your titles marks before your selected text. Make sure to leave a blank line before the first title your write.
::
    ## Architecture
    ### Modern architecture

Be careful not to use only one hashtag to create a first-level title as this
is usually used for pages main title.

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

Ordered and unordered lists
---------------------------

Insert a star ``*`` or a dash ``-`` followed by a single whitespace for each of your list item. One item per line. Leave a blank line before and after your list. For *ordered* list, use a digit followed by a dot and a whitespace instead.
::
    * A line
    - An other line
    * A unknown line

    1. The first item
    2. The second item
    3. The third item

If you need to break an item into several lines, you’ll need to use the line-break markup.

New paragraph and line-break
----------------------------

Hypertext links
---------------

Block quotes
------------

Images
------
