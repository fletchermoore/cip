Install
=======

This will set up a development environment:

1. Install Docker. Follow the instructions online to get setup on your machine.
2. Install docker-compose. Again, follow the online instructions for your machine.
3. Configure the `docker-compose.yml` file environmental variables. See the section below.
3. Run `./setup` from the application directory
4. Run `docker-compose run web mix create_admin` to enter an admin username and password
5. Run `docker-compose up -d` to start the server
6. Navigate to http://localhost:4000/ in your browser to log in, configure the website and create some users.

Alternatively, you can install PostgreSQL and Phoenix framework on your system
directly. Refer to the Phoenix Framework and PosgreSQL websites for instructions.
Ensure versions of Elixir, Erlang, Phoenix, etc. are the same.

The current version requires a Mailgun account as access is restricted and
users must first be invited by emmail. They can recover their passwords with email as well.
On the development version, emails can be seen by navigating to `/sent_emails` as per
the Bamboo mailer documentation.

docker-compose.yml
==================
You will need to update the URL_DOMAIN to your website domain and the URL_PORT to your port. These are
used by Phoenix to create URLs dynamically, such as http://URL_DOMAIN:URL_PORT/some/path

You will need to set MAILGUN_API_KEY and MAILGUN_DOMAIN per the Mailgun instructions. These do not need
to be set in the development environment as they are not used. I have only included them in this development
section so I will not forget about them when I set up a production environment.


Todo
====
- The current state of this product is a development only server. Setting up a production server is up to you for the time being. But making this trivial is my #1 priority.
- I will create options to disable or enable access restriction in the admin control panel.
- Currently, the website has been used for research so I need to remove the Experimental and Control group attributes from users. Full access is currently only available to "Experimental" group users.

Bugs
====
I have encountered a rare bug, I believe with sortable.js that stops the
drag and drop feature from working. This has required restarting the browser
to fix. I am unable to reproduce it reliably.
