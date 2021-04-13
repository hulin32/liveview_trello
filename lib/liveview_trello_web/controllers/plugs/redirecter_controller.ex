defmodule LiveviewTrelloWeb.Plugs.Redirector do
  use LiveviewTrelloWeb, :controller
  alias LiveviewTrello.Accounts.Guardian

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    maybe_user = Guardian.Plug.current_token(conn)
    if maybe_user do
      conn
      |> redirect(to: "/")
    end
    conn
  end
end
