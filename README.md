# OpusClassical

[![Elixir CI](https://github.com/Droidion/opus-classical-elixir/actions/workflows/elixir.yml/badge.svg)](https://github.com/Droidion/opus-classical-elixir/actions/workflows/elixir.yml)

Create file `config/dev.secret.exs` with the following content for connecting to database:

```elixir
import Config

config :opus_classical, OpusClassical.Repo,
  username: "postgres",
  password: "password",
  hostname: "db.yourname.supabase.co",
  database: "postgres",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Update esbuild `mix esbuild.install`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
