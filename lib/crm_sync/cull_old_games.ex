defmodule CrmSync.CullOldGames do
  @shortdoc "Culls old games"
  alias CrmSync.PeopleList

  def cull do
    people_lists = CrmSync.Repo.all(PeopleList)
    IO.puts "cull task ran"
    for p <- people_lists do
      IO.puts(p.list_name)
    end
  end

end