defmodule TimeManager.Account.UserRole do
  use Ecto.Schema
  import Ecto.Changeset
  schema "user_roles" do
    field :assigned_at, :utc_datetime
    belongs_to :user, TimeManager.Account.User
    belongs_to :role, TimeManager.Account.Role
    timestamps()
  end
  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id, :assigned_at])
    |> validate_required([:user_id, :role_id, :assigned_at])
    |> unique_constraint([:user_id, :role_id])
  end
end
