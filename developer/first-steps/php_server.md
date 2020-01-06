# Using PHP server for development

If *Vagrant* is too heavy for your purpose, you can simply use *PHP built-in server*.

Following command will launch a web-server listening on all IP addresses on port
8080. We also use a dedicated *router* file to serve static and generated resources:

```bash
# Create a new Roadiz project
composer create-project roadiz/standard-edition
# Create a new theme for your project
cd standard-edition
bin/roadiz themes:generate --symlink --relative FooBar

# Launch PHP server with web folder as root
php -S 0.0.0.0:8080 -t web vendor/roadiz/roadiz/conf/router.php
# OR use Makefile recipe
make dev-server
```

Standard Edition has a ``Makefile`` recipe for launching internal PHP server 
with a chosen port and IP: ``make dev-server``.

If you want to use PHP internal server, make sure you have installed all required
PHP extensions and that you have a database server:

- You can use a local MySQL/MariaDB server
- Or use a SQLite3 database, just use `../app/conf/database.db3` path during install.

> PHP web server was designed to aid application development. It may also be useful for testing purposes or for application demonstrations that are run in controlled environments. It is not intended to be a full-featured web server. It should not be used on a public network.

## Use Mailhog to catch outgoing emails

Contrary to *Vagrant*, using PHP built-in server does not provide any additional tool such as *Mailcatcher* or *Apache Solr*.
You can setup [Mailhog](https://github.com/mailhog/MailHog) to catch outgoing emails in a clean web interface.

On *macOS*, use *HomeBrew*: `brew update && brew install mailhog`, then configure your PHP `sendmail_path` to 
use it. 

