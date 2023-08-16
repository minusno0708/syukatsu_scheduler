defmodule SyukatsuScheduler.Accounts.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string
    field :status, :string
    field :schedule, :date
    field :url, :string

    belongs_to :user, SyukatsuScheduler.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :status, :schedule, :url, :user_id])
    |> validate_required([:name])
  end
end
