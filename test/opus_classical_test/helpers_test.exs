defmodule OpusClassical.HelpersTest do
  use ExUnit.Case

  import OpusClassical.Helpers

  test "is_valid_year identifies valid year" do
    assert is_valid_year(1000) == true
    assert is_valid_year(1234) == true
    assert is_valid_year(9999) == true
  end

  test "is_valid_year identifies invalid year" do
    assert is_valid_year(999) == false
    assert is_valid_year(10000) == false
    assert is_valid_year(0) == false
    assert is_valid_year(-1) == false
  end

  test "slice_year creates valid slice" do
    assert slice_year(1985) == "85"
    assert slice_year(9999) == "99"
  end

  test "century_equal returns true for equal centuries" do
    assert century_equal(1700, 1799) == true
    assert century_equal(1750, 1749) == true
  end

  test "century_equal returns false for non equal centuries" do
    assert century_equal(1699, 1700) == false
    assert century_equal(1799, 1800) == false
    assert century_equal(1200, 1500) == false
  end

  test "format_years_range_string formats years range" do
    assert format_years_range_string(1900, 1902) == "1900–02"
    assert format_years_range_string(1890, 1912) == "1890–1912"
    assert format_years_range_string(1890, 1) == "1890–"
    assert format_years_range_string(1, 1912) == ""
    assert format_years_range_string(1990, nil) == "1990–"
    assert format_years_range_string(-1, nil) == ""
  end

  test "format_work_length formats properly" do
    assert format_work_length(12) == "12m"
    assert format_work_length(59) == "59m"
    assert format_work_length(60) == "1h"
    assert format_work_length(62) == "1h 2m"
    assert format_work_length(123) == "2h 3m"
    assert format_work_length(nil) == ""
  end

  test "format_years_range_loose formats properly" do
    assert format_years_range_loose(1900, 1902) == "1900–02"
    assert format_years_range_loose(1890, 1912) == "1890–1912"
    assert format_years_range_loose(1890, 1) == "1890"
    assert format_years_range_loose(1, 1912) == "1912"
    assert format_years_range_loose(1990, nil) == "1990"
    assert format_years_range_loose(-1, nil) == ""
    assert format_years_range_loose(nil, 1900) == "1900"
    assert format_years_range_loose(nil, nil) == ""
  end
end
