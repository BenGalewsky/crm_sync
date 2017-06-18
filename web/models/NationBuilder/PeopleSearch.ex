defmodule NationBuilder.PeopleSearch do
  use HTTPoison.Base
  require Logger
  import Map
  use Timex
  alias CrmSync.Person
  import Ecto.Query
  alias CrmSync.Repo

  def process_url(url) do
    nation = Application.get_env(:crm_sync, NationBuilder.API)[:nation]
    addr = "https://#{nation}.nationbuilder.com"<>url
    IO.puts("------> "<>addr)
    addr
  end

  def process_request_headers(headers) do
      Dict.put headers, :"Accept", "application/json"
  end

  def process_response_body(html) do
    html
  end


 def time_of_last_upload do
    case Repo.one(from person in Person, select: max(person.crm_updated_at)) do
      nil -> Timex.to_datetime(Timex.parse!("1900-01-01", "{YYYY}-{0M}-{D}"))
      dt -> dt
    end
 end

 def format_updated_at_query(last_update) do
    df = Timex.format(last_update, "{ISO:Extended}")

    case df do
       {:ok, date_time} -> date_time
    end
 end

 def load_people_since(latest_update_time) do
    encoded_time = URI.encode(latest_update_time)
     api_key = Application.get_env(:crm_sync, NationBuilder.API)[:api_key]
     load_people("/api/v1/people/search?updated_since=#{encoded_time}&limit=10&access_token=#{api_key}")
 end


 def load_people(url, nonce \\ "", token \\ "") do
   new_url = if (nonce != "") do "#{url}&__nonce=#{nonce}&__token=#{token}" else url end
   with {:ok, body} <- fetch(new_url),
        {:ok, json_result} <- Poison.decode(body),
        {:ok, next_url} <- fetch(json_result, "next"),
        {:ok, result_list} <- fetch(json_result, "results") do
            save_people_records(result_list)

            if(next_url) do
                IO.puts("and moving on to " <> next_url <> "----> "<>extract_nonce(next_url))
                new_nonce = extract_nonce(next_url)
                new_token = extract_token(next_url)

                load_people(url, new_nonce, new_token)
            end
            {:ok, "Successfully loaded"}
        else {:error, reason} -> {:error, reason}
    end
 end

  # Map over each entry and generate a tuple for the select element with name and slug
  def save_people_records(people_list) do
    for person <- people_list do
        save_people_record(person)
    end
  end

  def save_people_record(json_result) do
    with {:ok, crm_id} <- fetch(json_result, "id"),
    {:ok, updated_at_str} <- fetch(json_result, "updated_at"),
    {:ok,crm_updated_at} <- Timex.parse(updated_at_str, "{ISO:Extended}"),
    {:ok, json_blob} <- Poison.encode(json_result)
     do
        person = %Person{crm_id: to_string(crm_id), crm_updated_at: crm_updated_at, json_blob: json_blob}
        Repo.insert!(person)
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

  def extract_nonce(url) do
    uri = URI.parse(url)
    keys = URI.decode_query(uri.query)
    keys["__nonce"]
  end

  def extract_token(url) do
    uri = URI.parse(url)
    keys = URI.decode_query(uri.query)
    keys["__token"]
  end
end