defmodule OpusClassical.Domain do
  @periods_composers_sql "select json from periods_composers"
  def get_composers() do
    case OpusClassical.Repo.query(@periods_composers_sql) do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> []
    end
  end
end
