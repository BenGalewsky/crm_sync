defmodule NationBuilder.PeopleSearch do
  use HTTPoison.Base
  require Logger
  import Map
  use Timex
  alias CrmSync.Person
  alias CrmSync.Repo

  def process_url(url) do
    nation = Application.get_env(:crm_sync, NationBuilder.API)[:nation]
    "https://#{nation}.nationbuilder.com"<>url
  end

  def process_request_headers(headers) do
      Dict.put headers, :"Accept", "application/json"
  end

  def process_response_body(html) do
    Logger.info("Got a response body")
#    Logger.info(html)
    html
  end



 def load_people() do
     api_key = Application.get_env(:crm_sync, NationBuilder.API)[:api_key]
     load_people("/api/v1/people/search?updated_since=2014-02-01T04%3A24%3A21-08%3A00&limit=1&access_token=#{api_key}")
 end


 def load_people(url) do
   with {:ok, body} <- fetch(url),
        {:ok, next_url} <- extractLists(body) do
            load_people(next_url)
            IO.puts("-------Next stop: "<>next_url)
            {:ok}
        else {:error, reason} -> {:error, reason}
    end
 end

  def extractLists(body) do
    with {:ok, json_result} <- Poison.decode(body),
         {:ok, next_url} <- fetch(json_result, "next"),
         {:ok, result_list} <- fetch(json_result, "results"),
         {:ok, extracted_list} <- extractList(result_list)
          do
            IO.puts("Next stop: "<>next_url)
            {:ok, next_url}
         else {:error, reason} -> {:error, "unable to parse response from nation builder"}
    end
  end

  # Map over each entry and generate a tuple for the select element with name and slug
  def extractList(result_list) do
    select_choices = for n <- result_list do
        save_people_record(n)
    end
    {:ok, select_choices}
  end

  def save_people_record(json_result) do
    with {:ok, crm_id} <- fetch(json_result, "id"),
    {:ok, updated_at_str} <- fetch(json_result, "updated_at"),
    {:ok,crm_updated_at} <- Timex.parse(updated_at_str, "{ISO:Extended}"),
    {:ok, json_blob} <- Poison.encode(json_result)
     do
        person = %Person{crm_id: to_string(crm_id), crm_updated_at: crm_updated_at, json_blob: json_blob}
        foo = Repo.insert!(person)
        IO.inspect(foo)
      else
        {:error, reason} -> {:error, "Can't do it"}
    end
  end

  def fetch(url) do
    NationBuilder.PeopleSearch.start
    case NationBuilder.PeopleSearch.get(url) do
      {:ok, response}   -> {:ok, response.body}
      {:error, reason}  -> {:ok, "Something went wrong"}
    end
  end
end