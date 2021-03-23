defmodule LiveviewTrello.Repo do
  use Ecto.Repo,
    otp_app: :liveview_trello,
    adapter: Ecto.Adapters.Postgres
end
