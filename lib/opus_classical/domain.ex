defmodule OpusClassical.Domain do
  @periods_composers_sql "SELECT json FROM periods_composers"
  @composer_sql "SELECT composer_by_slug($1) AS json"
  @genres_sql "SELECT genres_and_works_by_composer($1) AS json"
  @recordings_sql "SELECT recordings_by_work($1) AS json"
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
    case OpusClassical.Repo.query(@periods_composers_sql) do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> []
    end
  end

  def get_composer(slug) do
    case OpusClassical.Repo.query(@composer_sql, [slug]) do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> nil
    end
  end

  def get_genres(slug) do
    case OpusClassical.Repo.query(@genres_sql, [slug]) do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> nil
    end
  end

  def get_recordings(id) do
    case OpusClassical.Repo.query(@recordings_sql, [id]) do
      {:ok, %{rows: [[json]]}} -> json
      {_, _} -> nil
    end
  end

  def get_work(id) do
    case OpusClassical.Repo.query(@work_by_id, [id]) do
      {:ok, %{rows: [work | _]}} -> work
      {_, _} -> nil
    end
  end

  def get_child_works(id) do
    case OpusClassical.Repo.query(@child_works_by_parent_work_id, [id]) do
      {:ok, %{rows: works}} -> works
      {_, _} -> nil
    end
  end
end
