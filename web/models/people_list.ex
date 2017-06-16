defmodule CrmSync.PeopleList do
  use CrmSync.Web, :model

  schema "people_lists" do
    field :list_name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:list_name])
    |> validate_required([:list_name])
  end
end
