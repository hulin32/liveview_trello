defmodule LiveviewTrelloWeb.AuthController do
  use LiveviewTrelloWeb, :controller

  alias LiveviewTrello.Accounts
  alias LiveviewTrello.Accounts.User
  alias LiveviewTrello.Accounts.Guardian

  def index(conn, _params) do
    # user = Guardian.Plug.current_resource(conn)
    changeset = Accounts.login_user(%User{})
    render(conn, "index.html", changeset: changeset, error: "")
  end

  def login(conn, %{ "user" => params }) do
    %{ "email" => email, "password" => password } = params
    case Accounts.login_user(%User{}, params) do
      %Ecto.Changeset{valid?: true, changes: _} = changeset ->
        case Accounts.authenticate_by_username_and_pass(email, password) do
          {:ok, user} ->
            conn
            |> Guardian.Plug.sign_in(user)
            |> redirect(to: "/")
          {:error, _ } ->
            render(conn, "index.html", changeset: changeset, error: "Email or passwrod not right")
        end
      changeset ->
        render(conn, "index.html", %{ changeset: changeset |> Map.put(:action, :validate), error: "" })
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/sign_in")
  end
end
