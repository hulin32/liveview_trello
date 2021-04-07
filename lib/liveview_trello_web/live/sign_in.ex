defmodule LiveviewTrelloWeb.SignIn do
  use LiveviewTrelloWeb, :live_view

  alias LiveviewTrello.Accounts
  alias LiveviewTrello.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.register_user(%User{})
    {:ok, assign(socket, changeset: changeset, error: "")}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> Accounts.login_user(user_params)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, changeset: changeset, error: "")}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    %{ "password" => pass, "email" => email } = user_params
    case Accounts.authenticate_by_username_and_pass(email, pass) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User login successfully")
         |> push_redirect(to: "/")}

      {:error, _ } ->
        {:noreply, assign(socket, :error, "Email or passwrod not right")}
    end
  end
end
