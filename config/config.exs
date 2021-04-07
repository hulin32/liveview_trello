# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :liveview_trello,
  ecto_repos: [LiveviewTrello.Repo]

# Configures the endpoint
config :liveview_trello, LiveviewTrelloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dNyVOZgN6OvmipiPxklPn73wulvfc1N129Agx6MKf0StadrD4f32ylh1OGM3iNar",
  render_errors: [view: LiveviewTrelloWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveviewTrello.PubSub,
  live_view: [signing_salt: "yex+EmEV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :liveview_trello, LiveviewTrelloWeb.Guardian,
       issuer: "liveview_trello",
       secret_key: "qgGvNu0J5KEENRR+KOcoFZgoWUiHlnunlkioRTH4rDsu7UjbSfwEuxF5N+Uomis9"
