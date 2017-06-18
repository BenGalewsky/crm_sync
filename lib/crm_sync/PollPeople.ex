defmodule CrmSync.PollPeople do
  @shortdoc "Polls People from CRM"
  alias CrmSync.PeopleList

  def poll do
    IO.puts "poll task ran"
    dt = NationBuilder.PeopleSearch.time_of_last_upload
    date_time = NationBuilder.PeopleSearch.format_updated_at_query(dt)

    case NationBuilder.PeopleSearch.load_people_since(date_time) do
      {:ok, message} -> IO.puts("People load complete "<>message)
    end
  end

end