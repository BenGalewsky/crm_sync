defmodule CrmSync.Repo.Migrations.CreatePeopleListTable do
  use Ecto.Migration

  def change do
    create table(:people_lists) do
      add :list_name, :string

      timestamps()
    end
  end
end
