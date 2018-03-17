Install
=======

This will set up a development environment:

1. Install Docker. Follow the instructions online to get setup on your machine.
2. Install docker-compose. Again, follow the online instructions for your machine.
3. Configure the `docker-compose.yml` file environmental variables.
3. Run `./setup` from the application directory
4. Run `docker-compose run web mix create_admin` to enter an admin username and password
5. Run `docker-compose up -d` to start the server
6. Navigate to http://localhost:4000/admin in your browser to configure the website and create some users.

Alternatively, you can install PostgreSQL and Phoenix framework on your system
directly. Refer to the Phoenix Framework and PosgreSQL websites for instructions.
Ensure versions of Elixir, Erlang, Phoenix, etc. are the same.

The current version requires a Mailgun account as access is restricted and
users must first be invited by emmail. They can recover their passwords with email as well.
On the development version, emails can be seen by navigating to `/sent_emails` as per
the Bamboo mailer documentation.


TODO
====
- The current state of this product is a development only server. Setting up a production server is up to you for the time being. But making this trivial is my #1 priority.
- I will create options to disable or enable access restriction in the admin control panel.
- Currently, the website has been used for research so I need to remove the Experimental and Control group attributes from users. Full access is currently only available to "Experimental" group users.

BUGS
====
I have encountered a rare bug, I believe with sortable.js that stops the
drag and drop feature from working. This has required restarting the browser
to fix. I am unable to reproduce it reliably.
