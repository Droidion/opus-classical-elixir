defmodule OpusClassical.Helpers do
  @doc """
  Checks if given string is a 4 digits number, like "1234" (not "-123", "123", or "12345").
  """
  @spec is_valid_year(integer()) :: boolean()
  def is_valid_year(num) do
    num > 999 and num < 10_000
  end

  @doc """
  Returns slice of the full year, like 85 from 1985.
  """
  @spec slice_year(integer()) :: String.t()
  def slice_year(year) do
    year
    |> to_string()
    |> String.slice(2..4)
  end

  @doc """
  Checks if two given string have the same first two letters, like "1320" and "1399".
  """
  @spec century_equal(number(), number()) :: boolean()
  def century_equal(year1, year2) do
    is_integer(year1) && is_integer(year2) &&
      year1 |> to_string() |> String.slice(0..1) == year2 |> to_string() |> String.slice(0..1)
  end

  @doc """
  Formats the range of two years into the string, e.g. "1720–95", or "1720–1805", or "1720–".
  Start year and dash are always present.
  It's supposed to be used for lifespans, meaning we always have birth, but may not have death.
  """
  @spec format_years_range_string(integer(), integer() | nil) :: String.t()
  def format_years_range_string(start_year, finish_year) do
    cond do
      !is_valid_year(start_year) -> ""
      finish_year == nil -> "#{start_year}–"
      !is_valid_year(finish_year) -> "#{start_year}–"
      century_equal(start_year, finish_year) -> "#{start_year}–#{slice_year(finish_year)}"
      true -> "#{start_year}–#{finish_year}"
    end
  end

  @doc """
  Formats the range of two years into a string, e.g. "1720–95", or "1720–1805", or "1720".
  Both years can be present or absent, so it's a more generic, loose form.
  """
  @spec format_years_range_loose(integer() | nil, integer() | nil) :: String.t()
  def format_years_range_loose(start_year, finish_year) do
    cond do
      is_valid_year(start_year) and finish_year == nil -> to_string(start_year)
      start_year == nil and finish_year != nil -> to_string(finish_year)
      is_valid_year(start_year) and !is_valid_year(finish_year) -> to_string(start_year)
      !is_valid_year(start_year) and is_valid_year(finish_year) -> to_string(finish_year)
      century_equal(start_year, finish_year) -> "#{start_year}–#{slice_year(finish_year)}"
      start_year != nil and finish_year != nil -> "#{start_year}–#{finish_year}"
      true -> ""
    end
  end

  @doc """
  Formats minutes into a string with hours and minutes, like "2h 35m"
  """
  @spec format_work_length(integer()) :: String.t()
  def format_work_length(length_in_minutes) do
    hours = div(length_in_minutes || 0, 60)
    minutes = rem(length_in_minutes || 0, 60)

    case {hours, minutes} do
      {0, 0} -> ""
      {h, m} when h < 0 or m < 0 -> ""
      {0, m} -> "#{m}m"
      {h, 0} -> "#{h}h"
      {h, m} -> "#{h}h #{m}m"
    end
  end

  def format_catalogue_name(work) do
    postfix = work["cataloguePostfix"] || ""

    if work["catalogueName"] && work["catalogueNumber"] do
      "#{work["catalogueName"]} #{work["catalogueNumber"]}#{postfix}"
    else
      nil
    end
  end

  def format_work_name(work) do
    cond do
      work["no"] && work["nickname"] ->
        "#{work["title"]} No. #{work["no"]}&nbsp;<em>#{work["nickname"]}</em>"

      work["no"] && !work["nickname"] ->
        "#{work["title"]} No. #{work["no"]}"

      !work["no"] && work["nickname"] ->
        "#{work["title"]}&nbsp;<em>#{work["nickname"]}</em>"

      true ->
        work["title"]
    end
  end

  def map_work(work_as_list) do
    %{
      "id" => Enum.at(work_as_list, 0),
      "title" => Enum.at(work_as_list, 1),
      "yearStart" => Enum.at(work_as_list, 2),
      "yearFinish" => Enum.at(work_as_list, 3),
      "averageMinutes" => Enum.at(work_as_list, 4),
      "catalogueName" => Enum.at(work_as_list, 5),
      "catalogueNumber" => Enum.at(work_as_list, 6),
      "cataloguePostfix" => Enum.at(work_as_list, 7),
      "key" => Enum.at(work_as_list, 8),
      "no" => Enum.at(work_as_list, 9),
      "nickname" => Enum.at(work_as_list, 10)
    }
  end

  def enrich_work(work) do
    work
    |> Map.put(
      "composePeriod",
      format_years_range_loose(
        work["yearStart"],
        work["yearFinish"]
      )
    )
    |> Map.put(
      "averageLengthFormatted",
      format_work_length(work["averageMinutes"])
    )
    |> Map.put(
      "catalogueNotation",
      format_catalogue_name(work)
    )
    |> Map.put(
      "fullName",
      format_work_name(work)
    )
  end

  def enrich_recording(recording) do
    recording
    |> Map.put(
      "lengthFormatted",
      format_work_length(recording["length"])
    )
    |> Map.put(
      "recordingPeriod",
      format_years_range_loose(recording["yearStart"], recording["yearFinish"])
    )
  end
end
