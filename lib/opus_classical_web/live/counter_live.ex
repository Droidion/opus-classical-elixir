defmodule OpusClassicalWeb.CounterLive do
  use OpusClassicalWeb, :live_view
  alias Phoenix.LiveView.JS

  def show_search(js \\ %JS{}) do
    js
    |> JS.show(to: ".search-wrapper")
    |> JS.focus(to: ".search__field")
  end

  def hide_search(js \\ %JS{}) do
    js
    |> JS.hide(to: ".search-wrapper")
  end

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, search_results: [])
    {:ok, socket}
  end

  @impl true
  def handle_event("change_search", %{"searchInput" => query}, socket) do
    composers = OpusClassical.Domain.search_composers(query, 5)
    socket = assign(socket, search_results: composers)
    {:noreply, socket}
  end
end
