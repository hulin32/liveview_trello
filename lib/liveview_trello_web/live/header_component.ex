defmodule LiveviewTrelloWeb.HeaderComponent do
  use LiveviewTrelloWeb, :live_component

  @impl true
  def mount(socket) do
    socket = socket |> assign(:toggle_board, false)
    {:ok, socket}
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end

  @impl true
  def handle_event("toggle_board", _, socket) do
    socket = socket |> assign(:toggle_board, !socket.assigns.toggle_board);
    {:noreply, socket}
  end

end
