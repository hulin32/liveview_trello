defmodule LiveviewTrelloWeb.CardModalComponent do
  use LiveviewTrelloWeb, :live_component
  alias LiveviewTrello.{Repo, Card}

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
  def handle_event("add_comment", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_card", %{ "card" => params }, socket) do
    socket.assigns.current_card
      |> Card.changeset(params)
      |> Repo.update()

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
