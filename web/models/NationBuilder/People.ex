defmodule NationBuilder.People do
  use HTTPoison.Base
  require Logger
  require Map
  alias Map
  require OK

  @domain "https://evanowski.nationbuilder.com/api/v1/lists?limit=10&__proto__=&access_token=9b134cf2b044fc4bfe6eb2ca6c9db2fc281e80673ece2916c9307b88b506f566"

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

  def extractLists(body) do
    case Poison.decode(body) do
        {:ok, json_result} ->
            for n <- elem(Map.fetch(json_result, "results"),1) do
                {elem(Map.fetch(n, "name"),1), elem(Map.fetch(n,"slug"), 1)}
         end
        :error -> {:error, "Can't decode Json"}
    end
  end
end