defmodule CrmSync.Repo.Migrations.CreatePeopleList do
  use Ecto.Migration

  def change do
    create table(:people_lists) do
      add :list_name, :string

      timestamps()
    end

  end
end
