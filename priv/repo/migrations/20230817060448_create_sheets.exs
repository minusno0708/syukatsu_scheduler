defmodule SyukatsuScheduler.Repo.Migrations.CreateSheets do
  use Ecto.Migration

  def change do
    create table(:sheets) do
      add :item, :string
      add :content, :text
      add :company_id, references(:companies, on_delete: :nothing)

      timestamps()
    end

    create index(:sheets, [:company_id])
  end
end
