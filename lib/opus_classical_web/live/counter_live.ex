defmodule OpusClassicalWeb.CounterLive do
  use OpusClassicalWeb, :live_view
  alias Phoenix.LiveView.JS

  defp init_selected_item(cur_value, total_items) do
    if cur_value == nil and total_items > 0 do
      0
    else
      cur_value
    end
  end

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
    socket = assign(socket, search_results: [], selected_result: nil)
    {:ok, socket}
  end

  @impl true
  def handle_event("change_search", %{"searchInput" => query}, socket) do
    composers = OpusClassical.Domain.search_composers(query, 5)
    selected_result = init_selected_item(socket.assigns.selected_result, length(composers))
    socket = assign(socket, search_results: composers, selected_result: selected_result)
    {:noreply, socket}
  end

  @impl true
  def handle_event("handle_search_key_press", %{"key" => key_code}, socket) do
    selected_result =
      case {key_code} do
        {"ArrowUp"} ->
          if socket.assigns.selected_result > 0 do
            socket.assigns.selected_result - 1
          else
            length(socket.assigns.search_results) - 1
          end

        {"ArrowDown"} ->
          if socket.assigns.selected_result < length(socket.assigns.search_results) - 1 do
            socket.assigns.selected_result + 1
          else
            0
          end

        {_} ->
          socket.assigns.selected_result
      end

    socket =
      assign(socket,
        search_results: socket.assigns.search_results,
        selected_result: selected_result
      )

    {:noreply, socket}
  end
end
