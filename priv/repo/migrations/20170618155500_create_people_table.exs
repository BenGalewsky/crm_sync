defmodule CrmSync.Repo.Migrations.CreatePeopleTable do
  use Ecto.Migration

  def change do
        create table(:people) do
        add :crm_id, :string
        add :crm_updated_at, :utc_datetime
        add :json_blob, :text
          timestamps()
          end
  end
end
