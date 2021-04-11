defmodule LiveviewTrelloWeb.Home do
  use LiveviewTrelloWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(show_new_list: false)
      |> assign(show_new_card: %{})
      |> assign(show_new_memeber: false)
      |> assign(show_card_modal: false)
    }
  end

  @impl true
  def handle_event("new_list_toggle", _, socket) do
    show_new_list = !socket.assigns.show_new_list
    {:noreply,
      socket
      |> reset_all_toggle
      |> assign(show_new_list: show_new_list)
    }
  end

  @impl true
  def handle_event("save_new_list", params, socket) do
    # %{"list" => %{"name" => "sassasas"}}
    IO.inspect params
    {:noreply,
      socket
      |> reset_all_toggle
    }
  end

  @impl true
  def handle_event("new_card_toggle", %{ "card_id" => card_id }, socket) do
    show_new_card_map =
    case Map.fetch(socket.assigns.show_new_card, card_id) do
      {:ok, show_new_card} -> %{ card_id => !show_new_card }
      _ -> %{ card_id => true }
    end
    {:noreply,
      socket
      |> reset_all_toggle
      |> assign(show_new_card: show_new_card_map)
    }
  end

  @impl true
  def handle_event("save_new_card", params, socket) do
    # %{"card" => %{"name" => "sasasa"}, "list" => %{"id" => "2"}}
    IO.inspect params
    {:noreply,
      socket
      |> reset_all_toggle
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
  def handle_event("card_modal_toggle", _params, socket) do
    IO.inspect "sasasas"
    show_card_modal = !socket.assigns.show_card_modal
    {:noreply,
      socket
      |> reset_all_toggle
      |> assign(show_card_modal: show_card_modal)
    }
  end

  defp reset_all_toggle(socket) do
    socket
    |> assign(show_new_list: false)
    |> assign(show_new_card: %{})
    |> assign(show_new_memeber: false)
    |> assign(show_card_modal: false)
  end
end
