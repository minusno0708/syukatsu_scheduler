defmodule SyukatsuScheduler.EntrySheet.Sheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sheets" do
    field :item, :string
    field :content, :string
    field :company_id, :id

    timestamps()
  end

  @doc false
  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, [:item, :content])
    |> validate_required([:item, :content])
  end
end
