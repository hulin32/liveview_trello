defmodule LiveviewTrelloWeb.Home do
  use LiveviewTrelloWeb, :live_view
  import Ecto
  alias LiveviewTrello.Accounts.Guardian
  alias LiveviewTrello.{Repo, Board, UserBoard, Card}

  @impl true
  def mount(_params, %{ "guardian_default_token" => token }, socket) do
    socket =
    case Guardian.resource_from_token(token) do
      {:ok, user, _claims} ->
        socket
        |> assign(:current_user, user)
      _ -> socket
    end

    {:ok,
      socket
      |> load_boards()
      |> reset_all_toggle()
    }
  end

  @impl true
  def handle_event("new_board_toggle", _, socket) do
    show_new_board = !socket.assigns.show_new_board
    {:noreply,
      socket
      |> reset_all_toggle()
      |> assign(show_new_board: show_new_board)
    }
  end

  @impl true
  def handle_event("save_new_board", %{"board" => board_params}, socket) do
    changeset = socket.assigns.current_user
      |> build_assoc(:owned_boards)
      |> Board.changeset(board_params)

    if changeset.valid? do
      board = Repo.insert!(changeset)
      board
      |> build_assoc(:user_boards)
      |> UserBoard.changeset(%{user_id: socket.assigns.current_user.id})
      |> Repo.insert!
    end

    {:noreply,
      socket
      |> load_boards()
      |> reset_all_toggle()
    }
  end

  defp load_boards(socket) do
    owned_boards = socket.assigns.current_user
      |> assoc(:owned_boards)
      |> Repo.all

    invited_boards = socket.assigns.current_user
      |> assoc(:boards)
      |> Board.not_owned_by(socket.assigns.current_user.id)
      |> Repo.all

    socket
    |> assign(owned_boards: owned_boards)
    |> assign(invited_boards: invited_boards)
  end

  defp reset_all_toggle(socket) do
    socket
    |> assign(show_new_board: false)
    |> assign(show_new_card: %{})
    |> assign(show_new_memeber: false)
    |> assign(show_card_modal: false)
  end
end
