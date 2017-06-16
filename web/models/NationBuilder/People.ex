defmodule NationBuilder.People do
  use HTTPoison.Base
  require Logger
  import Map

  def process_url(url) do
    Application.get_env(:crm_sync, NationBuilder.API)[:endpoint]
  end

  def process_request_headers(headers) do
      Dict.put headers, :"Accept", "application/json"
  end

  def process_response_body(html) do
    Logger.info("Got a response body")
    Logger.info(html)
    html
  end

  def fetch do
    NationBuilder.People.start
    case NationBuilder.People.get("/") do
      {:ok, response}   -> {:ok, response.body}
      {:error, reason}  -> {:ok, "Something went wrong"}
    end
  end

 def extractLists() do
   with {:ok, body} <- fetch(),
        {:ok, select_choice} <- extractLists(body) do
            {:ok, select_choice}
        else {:error, reason} -> {:error, reason}
    end
 end

  def extractLists(body) do
    with {:ok, json_result} <- Poison.decode(body),
         {:ok, result_list} <- fetch(json_result, "results") do
            extractList(result_list)
         else {:error, reason} -> {:error, "unable to parse response from nation builder"}
    end
  end

  # Map over each entry and generate a tuple for the select element with name and slug
  def extractList(result_list) do
    select_choices = for n <- result_list do
        with {:ok, name} <- fetch(n, "name"),
        {:ok, slug} <- fetch(n, "slug") do
          {name, slug}
        end
    end
    {:ok, select_choices}
  end
end