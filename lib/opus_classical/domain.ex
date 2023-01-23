defmodule OpusClassical.Domain do
  @periods_composers_sql "SELECT json FROM periods_composers"
  @composer_sql "SELECT composer_by_slug($1) AS json"
  @genres_sql "SELECT genres_and_works_by_composer($1) AS json"
  @recordings_sql "SELECT recordings_by_work($1) AS json"
  @search_sql "SELECT id, first_name, last_name, slug, last_name_score FROM search_composers_by_last_name($1, $2)"
  @work_by_id """
    select w.id,
           w.title,
           w.year_start,
           w.year_finish,
           w.average_minutes,
           c.name catalogue_name,
           w.catalogue_number ,
           w.catalogue_postfix,
           k.name as key,
           w.no,
           w.nickname
    from works w
             left join catalogues c on w.catalogue_id = c.id
             left join keys k on w.key_id = k.id
    where w.id = $1
  """
  @child_works_by_parent_work_id """
    select w.id,
           w.title,
           w.year_start,
           w.year_finish,
           w.average_minutes,
           c.name as catalogue_name,
           w.catalogue_number,
           w.catalogue_postfix,
           k.name as key,
           w.no,
           w.nickname
    from works w
             left join catalogues c on w.catalogue_id = c.id
             left join keys k on w.key_id = k.id
    where w.parent_work_id = $1
    order by sort, year_finish, no, catalogue_number, catalogue_postfix, nickname
  """

  def get_composers() do
    case @periods_composers_sql |> OpusClassical.Repo.query() do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> []
    end
  end

  def get_composer(slug) do
    case @composer_sql |> OpusClassical.Repo.query([slug]) do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> nil
    end
  end

  def get_genres(slug) do
    case @genres_sql |> OpusClassical.Repo.query([slug]) do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> nil
    end
  end

  def get_recordings(id) do
    case @recordings_sql |> OpusClassical.Repo.query([id]) do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> nil
    end
  end

  def get_work(id) do
    case @work_by_id |> OpusClassical.Repo.query([id]) do
      {:ok, %{rows: [work | _]}} -> work
      {_, _} -> nil
    end
  end

  def get_child_works(id) do
    case @child_works_by_parent_work_id |> OpusClassical.Repo.query([id]) do
      {:ok, %{rows: works}} -> works
      {_, _} -> nil
    end
  end

  def search_composers(query, limit) do
    case @search_sql |> OpusClassical.Repo.query([query, limit]) do
      {:ok, %{rows: composers}} -> composers
      {_, _} -> []
    end
  end
end
