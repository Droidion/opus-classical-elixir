defmodule OpusClassical.Domain do
    def get_composers() do
        sql = "SELECT name, year FROM composers"
        case OpusClassical.Repo.query(sql) do
            {:ok, %{rows: rows}} -> rows
            {_, _} -> []
        end
    end
end