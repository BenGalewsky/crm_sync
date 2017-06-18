defmodule CrmSync.PersonTest do
  use CrmSync.ModelCase

  alias CrmSync.Person

  @valid_attrs %{crm_id: "some content", json_blob: "some content", updated_at: %{day: 17, month: 4, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Person.changeset(%Person{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Person.changeset(%Person{}, @invalid_attrs)
    refute changeset.valid?
  end
end
