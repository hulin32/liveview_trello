defmodule LiveviewTrelloWeb.CardModalComponent do
  use LiveviewTrelloWeb, :live_component
  alias LiveviewTrello.{Repo, Card, Comment}
  import Ecto

  @impl true
  def mount(socket) do
    {:ok,
      socket
      |> reset_all_toggle()
    }
  end

  # @impl true
  # def update(assigns, socket) do
  #   IO.inspect(assigns)
  #   {:ok, socket}
  # end

  @impl true
  def handle_event("toggle_edit", _, socket) do
    {:noreply,
      socket
      |> assign(show_card_edit: !socket.assigns.show_card_edit)
    }
  end

  @impl true
  def handle_event("update_card", %{ "card" => params }, socket) do
    IO.inspect(params)
    socket.assigns.current_card
      |> Card.changeset(params)
      |> Repo.update()

    send self(), {:reload_current_card}
    {:noreply,
      socket
      |> reset_all_toggle()
    }
  end

  @impl true
  def handle_event("add_comment", %{ "card" => %{ "content" => content } }, socket) do
    user_id = socket.assigns.current_user.id
    changeset = socket.assigns.current_card
      |> build_assoc(:comments)
      |> Comment.changeset(%{ "content" => content, "user_id" => user_id })

    if changeset.valid? do
      Repo.insert!(changeset)
    end

    send self(), {:reload_current_card}
    {:noreply,
      socket
      |> reset_all_toggle()
    }
  end

  defp reset_all_toggle(socket) do
    socket
    |> assign(show_card_edit: false)
  end
end
