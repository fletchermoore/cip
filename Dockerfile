FROM elixir:1.6

RUN apt-get update -q
RUN apt-get install -y inotify-tools nodejs

# Install NodeJS and the NPM
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y -q nodejs

RUN mix local.hex --force

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

RUN mix local.rebar --force

WORKDIR /app
