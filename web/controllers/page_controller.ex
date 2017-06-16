defmodule CrmSync.PageController do
  use CrmSync.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
