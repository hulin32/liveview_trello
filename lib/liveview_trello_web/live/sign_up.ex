defmodule LiveviewTrelloWeb.SignUp do
  use LiveviewTrelloWeb, :live_view

  alias LiveviewTrello.Accounts
  alias LiveviewTrello.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.register_user(%User{})
    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> Accounts.register_user(user_params)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_redirect(to: "/sign_in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
