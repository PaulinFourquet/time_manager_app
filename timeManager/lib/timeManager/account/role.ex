defmodule TimeManager.Account.Role do
  use Ecto.Schema
  import Ecto.Changeset
  schema "roles" do
    field :name, :string
    field :description, :string
    many_to_many :users, TimeManager.Account.User, join_through: "user_roles"
    timestamps()
  end
  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
