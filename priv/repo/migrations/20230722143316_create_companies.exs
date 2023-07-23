defmodule SyukatsuScheduler.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :status,:string
      add :schedule,:date
      add :url, :string

      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
