defmodule CrmSync.PeopleListController do
  use CrmSync.Web, :controller

  alias CrmSync.PeopleList
  require Logger

  def index(conn, _params) do
    people_lists = Repo.all(PeopleList)
    render(conn, "index.html", people_lists: people_lists)
  end

  def new(conn, _params) do
    changeset = PeopleList.changeset(%PeopleList{})
    case NationBuilder.People.fetch do
      {:ok, response} ->
         render(conn, "new.html", changeset: changeset, categories: NationBuilder.People.extractLists(response))
      {:error, reason} ->
        json(conn, reason)
    end
  end

  def create(conn, %{"people_list" => people_list_params}) do
    changeset = PeopleList.changeset(%PeopleList{}, people_list_params)

    case Repo.insert(changeset) do
      {:ok, _people_list} ->
        conn
        |> put_flash(:info, "People list created successfully.")
        |> redirect(to: people_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    people_list = Repo.get!(PeopleList, id)
    render(conn, "show.html", people_list: people_list)
  end

  def edit(conn, %{"id" => id}) do
    people_list = Repo.get!(PeopleList, id)
    changeset = PeopleList.changeset(people_list)
    render(conn, "edit.html", people_list: people_list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "people_list" => people_list_params}) do
    people_list = Repo.get!(PeopleList, id)
    changeset = PeopleList.changeset(people_list, people_list_params)

    case Repo.update(changeset) do
      {:ok, people_list} ->
        conn
        |> put_flash(:info, "People list updated successfully.")
        |> redirect(to: people_list_path(conn, :show, people_list))
      {:error, changeset} ->
        render(conn, "edit.html", people_list: people_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    people_list = Repo.get!(PeopleList, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(people_list)

    conn
    |> put_flash(:info, "People list deleted successfully.")
    |> redirect(to: people_list_path(conn, :index))
  end
end
