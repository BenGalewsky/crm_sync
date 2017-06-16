defmodule CrmSync.Router do
  use CrmSync.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CrmSync do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/people_lists", PeopleListController

  end

  # Other scopes may use custom stacks.
  # scope "/api", CrmSync do
  #   pipe_through :api
  # end
end
