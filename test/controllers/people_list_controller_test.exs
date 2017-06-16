defmodule CrmSync.PeopleListControllerTest do
  use CrmSync.ConnCase

  alias CrmSync.PeopleList
  @valid_attrs %{list_name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, people_list_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing people lists"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, people_list_path(conn, :new)
    assert html_response(conn, 200) =~ "New people list"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, people_list_path(conn, :create), people_list: @valid_attrs
    assert redirected_to(conn) == people_list_path(conn, :index)
    assert Repo.get_by(PeopleList, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, people_list_path(conn, :create), people_list: @invalid_attrs
    assert html_response(conn, 200) =~ "New people list"
  end

  test "shows chosen resource", %{conn: conn} do
    people_list = Repo.insert! %PeopleList{}
    conn = get conn, people_list_path(conn, :show, people_list)
    assert html_response(conn, 200) =~ "Show people list"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, people_list_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    people_list = Repo.insert! %PeopleList{}
    conn = get conn, people_list_path(conn, :edit, people_list)
    assert html_response(conn, 200) =~ "Edit people list"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    people_list = Repo.insert! %PeopleList{}
    conn = put conn, people_list_path(conn, :update, people_list), people_list: @valid_attrs
    assert redirected_to(conn) == people_list_path(conn, :show, people_list)
    assert Repo.get_by(PeopleList, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    people_list = Repo.insert! %PeopleList{}
    conn = put conn, people_list_path(conn, :update, people_list), people_list: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit people list"
  end

  test "deletes chosen resource", %{conn: conn} do
    people_list = Repo.insert! %PeopleList{}
    conn = delete conn, people_list_path(conn, :delete, people_list)
    assert redirected_to(conn) == people_list_path(conn, :index)
    refute Repo.get(PeopleList, people_list.id)
  end
end
