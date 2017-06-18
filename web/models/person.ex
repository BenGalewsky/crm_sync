defmodule CrmSync.Person do
  use CrmSync.Web, :model

  schema "people" do
    field :crm_id, :string
    field :crm_updated_at, Timex.Ecto.DateTime
    field :json_blob, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    IO.inspect(params)
    struct
    |> cast(params, [:crm_id, :crm_updated_at, :json_blob])
    |> validate_required([:crm_id, :crm_updated_at, :json_blob])
  end

end
