# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :phoenix_h2load, PhoenixH2loadWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hx6fx/3DMzG1kL3U+HL5mmnGWtoULk8qALWp3mfpiN0JtF//XKTDr7NiPMCxap32",
  render_errors: [view: PhoenixH2loadWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PhoenixH2load.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
