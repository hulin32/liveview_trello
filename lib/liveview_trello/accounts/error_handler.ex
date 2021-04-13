defmodule LiveviewTrello.Accounts.ErrorHandler do
  import Plug.Conn
  use LiveviewTrelloWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> redirect(to: "/sign_in")
    |> halt()
  end
end
