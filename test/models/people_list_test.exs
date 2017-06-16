defmodule CrmSync.PeopleListTest do
  use CrmSync.ModelCase

  alias CrmSync.PeopleList

  @valid_attrs %{list_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PeopleList.changeset(%PeopleList{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PeopleList.changeset(%PeopleList{}, @invalid_attrs)
    refute changeset.valid?
  end
end
