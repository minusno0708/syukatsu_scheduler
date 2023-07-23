defmodule SyukatsuScheduler.Accounts.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string
    field :url, :string

    belongs_to :user, SyukatsuScheduler.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :url])
    |> validate_required([:name])
  end
end
