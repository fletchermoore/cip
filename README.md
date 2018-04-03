Install
=======

This will set up a production environment:

1. Install Docker. Follow the instructions online (https://docs.docker.com/install/) to get setup on your machine.
2. Install docker-compose. Again, follow the online instructions (https://docs.docker.com/compose/install/) for your machine.
3. Configure the `docker-compose.yml` file environmental variables. See the section below.
3. Run `./setup` from the application directory. Take a look at this file to see what it is doing.
4. Run `docker-compose run web mix create_admin` to enter an admin username and password
5. Run `docker-compose up -d web` to start the server. `docker-compose down` stops the server.
6. Navigate to http://localhost:4001/admin in your browser to log in, configure the website and create some users.

Alternatively, you can install PostgreSQL and Phoenix framework on your system
directly. Refer to the Phoenix Framework and PosgreSQL websites for instructions.
Ensure versions of Elixir, Erlang, Phoenix, etc. are the same.

The current/default version uses a mailgun.com account to create access restriction. Users must first be invited by email. They can recover their passwords with email as well. If you do not intend
to create individual users. Select the option to make the website available to the public from
the Users page of the control panel. If Mailgun does not make sense for your use case, you
will need to configure a different email server with Bamboo. Check out that project on Github
for more information. On the development version, emails can be seen by navigating to `/sent_emails` as per the Bamboo mailer documentation.

docker-compose.yml
==================
You will need to update the `URL_DOMAIN` to your website domain and the `URL_PORT` to your port. These are
used by Phoenix to create URLs dynamically, such as http://URL_DOMAIN:URL_PORT/some/path

You will need to set `MAILGUN_API_KEY` and `MAILGUN_DOMAIN` per the Mailgun instructions. 


Bugs
====
I have encountered a rare bug, I believe with sortable.js that stops the
drag and drop feature from working. This has required restarting the browser
to fix. I am unable to reproduce it reliably.
