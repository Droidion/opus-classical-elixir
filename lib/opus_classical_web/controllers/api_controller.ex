defmodule OpusClassicalWeb.ApiController do
  use OpusClassicalWeb, :controller

  defp map_search(search_as_list) do
    %{
      "id" => Enum.at(search_as_list, 0),
      "firstName" => Enum.at(search_as_list, 1),
      "lastName" => Enum.at(search_as_list, 2),
      "slug" => Enum.at(search_as_list, 3),
      "lastNameScore" => Enum.at(search_as_list, 4)
    }
  end

  def search(conn, %{"q" => query}) do
    composers =
      query
      |> OpusClassical.Domain.search_composers(5)
      |> Enum.map(&map_search/1)

    conn |> json(composers)
  end
end
