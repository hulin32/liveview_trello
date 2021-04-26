defmodule LiveviewTrelloWeb.Board do
  use LiveviewTrelloWeb, :live_view
  import Ecto
  import Ecto.Query
  alias LiveviewTrello.Accounts.Guardian
  alias LiveviewTrello.{Repo, Board, UserBoard, Card}

  @impl true
  def mount(%{ "id" => id }, %{ "guardian_default_token" => token }, socket) do
    {board_id, _} =
      id
      |> String.split("-")
      |> Enum.at(0)
      |> Integer.parse()

    socket = socket |> assign(:board_id, board_id)

    socket = load_current_board(socket)

    socket =
      case Guardian.resource_from_token(token) do
        {:ok, user, _claims} ->
          socket
          |> assign(:current_user, user)
        _ -> socket
      end

    current_board = socket.assigns.current_board;
    if current_board === nil or socket.assigns.current_user.id !== current_board.user.id do
      {:ok,
        socket
          |> reset_all_toggle()
          |> load_boards()
          |> assign(:error, "No related board found")
      }
    else
      {:ok,
        socket
        |> reset_all_toggle()
        |> load_boards()
      }
    end
  end

  @impl true
  def handle_event("new_list_toggle", _params, socket) do
    show_new_list = !socket.assigns.show_new_list
    {:noreply,
      socket
      |> reset_all_toggle()
      |> assign(show_new_list: show_new_list)
    }
  end

  @impl true
  def handle_event("save_new_list", %{"list" => params}, socket) do
    changeset = socket.assigns.current_board
      |> build_assoc(:lists)
      |> LiveviewTrello.List.changeset(params)

    if changeset.valid? do
      Repo.insert!(changeset)
    end

    {:noreply,
      socket
      |> reset_all_toggle()
      |> load_boards()
      |> load_current_board()
    }
  end

  @impl true
  def handle_event("new_card_toggle", %{ "list_id" => list_id }, socket) do
    show_new_card_map =
      case Map.fetch(socket.assigns.show_new_card, list_id) do
        {:ok, show_new_card} -> %{ list_id => !show_new_card }
        _ -> %{ list_id => true }
      end

    {:noreply,
      socket
      |> reset_all_toggle
      |> assign(show_new_card: show_new_card_map)
    }
  end

  @impl true
  def handle_event("save_new_card", %{"card" => params, "list" => %{"id" => list_id}}, socket) do
    list = LiveviewTrello.List
      |> where(id: ^list_id)
      |> Repo.one()

    changeset = list
      |> build_assoc(:cards)
      |> LiveviewTrello.Card.changeset(params)
    if changeset.valid? do
      Repo.insert!(changeset)
    end

    {:noreply,
      socket
      |> reset_all_toggle()
      |> load_boards()
      |> load_current_board()
    }
  end

  @impl true
  def handle_event("new_member_toggle", _, socket) do
    show_new_memeber = !socket.assigns.show_new_memeber
    {:noreply,
      socket
      |> reset_all_toggle
      |> assign(show_new_memeber: show_new_memeber)
    }
  end

  @impl true
  def handle_event("save_new_member", params, socket) do
    # %{"member" => %{"email" => "sasa@182.com"}}
    IO.inspect params
    {:noreply,
      socket
      |> reset_all_toggle
    }
  end

  @impl true
  def handle_event("card_modal_toggle", params, socket) do
    show_card_modal = !socket.assigns.show_card_modal
    IO.inspect("show_card_modal")
    IO.inspect(params)
    IO.inspect(socket.assigns.show_card_modal)
    {:noreply,
      socket
      |> reset_all_toggle
      |> assign(show_card_modal: !socket.assigns.show_card_modal)
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
    |> assign(error: "")
    |> assign(show_new_list: false)
    |> assign(show_new_card: %{})
    |> assign(show_new_memeber: false)
    |> assign(show_card_modal: false)
    |> assign(current_card: %{})
  end

  def load_current_board(socket) do
    current_board = Board
      |> where(id: ^socket.assigns.board_id)
      |> Board.preload_board_all
      |> Repo.one()
    socket
      |> assign(:current_board, current_board)
  end
end
