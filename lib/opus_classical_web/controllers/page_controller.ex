defmodule OpusClassicalWeb.PageController do
  use OpusClassicalWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:composers, OpusClassical.Domain.get_composers())
    |> render("index.html")
  end
end
