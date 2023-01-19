defmodule OpusClassicalWeb.CounterLive do
  use OpusClassicalWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, count: 0)
    {:ok, socket}
  end

  @impl true
  def handle_event("increase", _, socket) do
    # Add 1 to the current count
    socket = assign(socket, count: socket.assigns.count + 1)
    {:noreply, socket}
  end

  @impl true
  def handle_event("decrease", _, socket) do
    # Substract 1 to the current count
    socket = assign(socket, count: socket.assigns.count - 1)
    {:noreply, socket}
  end
end
