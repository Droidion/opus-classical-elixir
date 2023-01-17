defmodule OpusClassicalWeb.PageController do
  use OpusClassicalWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:foo, "bar")
    |> render("index.html")
  end
end
