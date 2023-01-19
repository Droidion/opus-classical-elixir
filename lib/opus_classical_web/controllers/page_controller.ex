defmodule OpusClassicalWeb.PageController do
  use OpusClassicalWeb, :controller

  def periods(conn, _params) do
    conn
    |> assign(:composers, OpusClassical.Domain.get_composers())
    |> render("periods.html")
  end

  def about(conn, _params) do
    conn |> render("about.html")
  end

  def composer(conn, %{"slug" => slug}) do
    composer = OpusClassical.Domain.get_composer(slug)

    genres =
      composer["id"]
      |> OpusClassical.Domain.get_genres()
      |> Enum.map(fn genre ->
        Map.put(
          genre,
          "works",
          genre["works"] |> Enum.map(&OpusClassical.Helpers.enrich_work/1)
        )
      end)

    conn
    |> assign(:composer, composer)
    |> assign(:genres, genres)
    |> render("composer.html")
  end

  def work(conn, %{"slug" => slug, "id" => id}) do
    id_as_numb = String.to_integer(id)
    IO.inspect(id_as_numb)

    work =
      id_as_numb
      |> OpusClassical.Domain.get_work()
      |> OpusClassical.Helpers.map_work()
      |> OpusClassical.Helpers.enrich_work()

    IO.inspect(work)

    child_works =
      id_as_numb
      |> OpusClassical.Domain.get_child_works()
      |> Enum.map(fn work ->
        work |> OpusClassical.Helpers.map_work() |> OpusClassical.Helpers.enrich_work()
      end)

    IO.inspect(child_works)
    composer = OpusClassical.Domain.get_composer(slug)
    IO.inspect(composer)

    recordings =
      id_as_numb
      |> OpusClassical.Domain.get_recordings()
      |> Enum.map(fn recording -> recording |> OpusClassical.Helpers.enrich_recording() end)

    IO.inspect(recordings)

    conn
    |> assign(:work, work)
    |> assign(:child_works, child_works)
    |> assign(:composer, composer)
    |> assign(:recordings, recordings)
    |> assign(:static_assets_url, "https://opusclassical.zunh.nl-ams1.upcloudobjects.com/")
    |> render("work.html")
  end
end
