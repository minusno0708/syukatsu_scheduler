defmodule SyukatsuScheduler.EntrySheet.Sheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sheets" do
    field :item, :string
    field :content, :string

    belongs_to :company, SyukatsuScheduler.Accounts.Company

    timestamps()
  end

  @doc false
  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, [:item, :content, :company_id])
    |> validate_required([:item])
  end
end
