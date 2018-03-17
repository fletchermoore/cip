# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
#
#
use Mix.Config

# General application configuration
config :cip,
  ecto_repos: [Cip.Repo]

# Configures the endpoint
config :cip, CipWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CipWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cip.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :cip, Cip.Guardian,
      issuer: "cip",
      permissions: %{
        user: [:admin, :control, :exp]
      }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# IMPORT secrets file
# you need to create this file with the mix task create_secrets
# keep it out of version control
if File.exists?("cip.secret.exs") do import_config "cip.secret.exs" end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
