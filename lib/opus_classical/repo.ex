defmodule OpusClassical.Repo do
  use Ecto.Repo,
    otp_app: :opus_classical,
    adapter: Ecto.Adapters.Postgres
end
