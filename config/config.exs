# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :opus_classical,
  ecto_repos: [OpusClassical.Repo]

# Configures the endpoint
config :opus_classical, OpusClassicalWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: OpusClassicalWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: OpusClassical.PubSub,
  live_view: [signing_salt: "AhutMfSa"]

# Configure esbuild (the version is required)
config :dart_sass,
  version: "1.57.1",
  default: [
    args: [
      "css/app.sass",
      "../priv/static/assets/app.css"
    ],
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
